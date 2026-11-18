// 手机屏 App 资源库的统一数据源：在跑的 App 和各自的窗口、本机装着的 App、App 图标，界面只从这里读，
// 控制器决定「点一个 App 做什么」也看这里。系统读取在 SnugSystem（AppService、WindowService）。
// 列表露着时每 1.5 秒刷新在跑的 App：每次露出来第一次按最近用过重排，之后只增删、不换位置（见 AppList.keepingOrder）；
// 装着的 App 每次露出来读一次。收起就停；正在放窗口时暂停（列表被盖住，刷了也看不见，还和搬窗口排同一条队）；
// 一次远程结束就清空，下次从头读。手机上退掉的 App、关掉的窗口，PhoneDesk 一确认就从这里去掉，不等下一轮
import AppKit
import Combine
import SnugCore
import SnugSystem

@MainActor
final class AppCatalog: ObservableObject {
    static let refreshInterval: TimeInterval = 1.5

    @Published private(set) var running: [RunningApp]
    /// 字典序
    @Published private(set) var installed: [InstalledApp]
    /// 第一次刷新完成前显示「正在读取」，不显示「没有」
    @Published private(set) var loaded: Bool

    private let apps: AppService?
    private let windows: WindowService?
    private var refreshing: Task<Void, Never>?
    private var scanning: Task<Void, Never>?
    private var paused = false
    private var icons: [String: NSImage] = [:]
    /// forget 过几次：刷新读到一半时有东西没了，读出来的那份可能还带着它，丢掉重读
    private var forgotten = 0

    init(apps: AppService, windows: WindowService) {
        self.apps = apps
        self.windows = windows
        running = []
        installed = []
        loaded = false
    }

    /// 渲染样例用：固定的内容，不刷新
    init(sample running: [RunningApp], installed: [InstalledApp], loaded: Bool = true) {
        apps = nil
        windows = nil
        self.running = running
        self.installed = AppList.sorted(installed)
        self.loaded = loaded
    }

    func startRefreshing() {
        guard refreshing == nil, let apps, let windows else { return }
        scanning = Task { [weak self] in
            let list = AppList.sorted(await apps.installed())
            guard let self, !Task.isCancelled, list != installed else { return }
            installed = list
        }
        refreshing = Task { [weak self] in
            var reorder = true
            while !Task.isCancelled {
                guard let self else { return }
                if !paused {
                    let before = forgotten
                    let fresh = await windows.withWindows(apps.running())
                    guard !Task.isCancelled else { return }
                    guard forgotten == before else { continue }
                    let next = reorder ? fresh : AppList.keepingOrder(of: running, updatedWith: fresh)
                    if next != running { running = next }
                    if !loaded { Log.info("App 资源库首次读取完成（运行中 \(next.count) 个 App）") }
                    loaded = true
                    reorder = false
                }
                try? await Task.sleep(for: .seconds(Self.refreshInterval))
            }
        }
    }

    func stopRefreshing() {
        refreshing?.cancel()
        refreshing = nil
        scanning?.cancel()
        scanning = nil
    }

    /// 暂停、继续刷新：不重开，继续后也不重排
    func setPaused(_ on: Bool) { paused = on }

    /// 一次远程结束：停下、清空，下次露出时显示「正在读取」，不拿上次的旧列表
    func reset() {
        stopRefreshing()
        running = []
        loaded = false
    }

    /// 退完了的 App、关上了的窗口：马上去掉，顺序不动（见 PhoneDesk.onGone）
    func forget(_ gone: PhoneDesk.Gone) {
        forgotten += 1
        switch gone {
        case .app(let pid):
            running.removeAll { $0.pid == pid }
        case .window(let key):
            guard let index = running.firstIndex(where: { $0.pid == key.pid }) else { return }
            running[index].windows.removeAll { $0.key == key }
        }
    }

    /// 在跑的这个 App（搜索结果里写它开着几个窗口）
    func running(_ app: AppInfo) -> RunningApp? { running.first { $0.app.bundleID == app.bundleID } }

    /// 窗口所属的在跑 App，这个窗口排第一个、用列表里最新的样子（终端的标题跟着命令变）。
    /// 列表还没刷到它（刚打开的 App，正在放窗口时列表暂停）就用窗口自己带的补上
    func app(of window: WindowInfo) -> RunningApp {
        let found = running.first { $0.pid == window.key.pid }
        let windows = found?.windows ?? []
        let latest = windows.first { $0.key == window.key } ?? window
        return RunningApp(pid: window.key.pid,
                          app: found?.app ?? AppInfo(bundleID: window.bundleID ?? "", name: window.app, path: nil),
                          windows: [latest] + windows.filter { $0.key != window.key })
    }

    func icon(for app: AppInfo) -> NSImage {
        if let cached = icons[app.bundleID] { return cached }
        let icon = AppService.icon(for: app)
        icons[app.bundleID] = icon
        return icon
    }

    /// 窗口所属 App 的图标
    func icon(for window: WindowInfo) -> NSImage { icon(for: app(of: window).app) }
}
