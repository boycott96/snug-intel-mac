import Combine
import SnugCore
import Testing
@testable import Snug

@Suite("兼容 macOS 13 的界面状态通知")
@MainActor
struct StateObservationTests {
    @Test("相同的状态不重发；授权、嵌套设置和更新进度的变化都能通知界面")
    func appStateChanges() {
        let state = AppState()
        var changes = 0
        let subscription = state.objectWillChange.sink { changes += 1 }
        defer { subscription.cancel() }

        state.update(\.accessibilityTrusted, false)
        #expect(changes == 0)
        state.update(\.accessibilityTrusted, true)
        #expect(changes == 1)
        state.update(\.accessibilityTrusted, true)
        #expect(changes == 1)
        state.config.gestures.toggle()
        #expect(changes == 2)
        state.update.phase = .checking
        #expect(changes == 3)
    }

    @Test("搜索词变化不切换键盘焦点；关闭后清空搜索，再关一次不重发页面切换")
    func pageChanges() {
        let pages = PhonePages()
        var transitions = 0
        let subscription = pages.$page.removeDuplicates().dropFirst().sink { _ in transitions += 1 }
        defer { subscription.cancel() }

        pages.open(.search)
        pages.query = "test"
        #expect(pages.active && pages.trimmedQuery == "test")
        #expect(transitions == 1)
        pages.close()
        pages.close()
        #expect(!pages.active && pages.query.isEmpty)
        #expect(transitions == 2)
    }

    @Test("从 App 资源库移除窗口会通知界面；会话结束清空运行列表与读取状态")
    func catalogChanges() {
        let info = AppInfo(bundleID: "test.snug", name: "Test", path: nil)
        let window = WindowInfo(key: WindowKey(pid: 42, id: 43), app: "Test", bundleID: info.bundleID, title: "Test")
        let catalog = AppCatalog(sample: [RunningApp(pid: 42, app: info, windows: [window])], installed: [])
        var changes = 0
        let subscription = catalog.objectWillChange.sink { changes += 1 }
        defer { subscription.cancel() }

        catalog.forget(.window(window.key))
        #expect(catalog.running.first?.windows.isEmpty == true)
        #expect(changes > 0)
        catalog.reset()
        #expect(catalog.running.isEmpty && !catalog.loaded)
    }
}
