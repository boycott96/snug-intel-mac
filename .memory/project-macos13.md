# macOS 13 兼容

最低运行版本为 macOS 13，`Package.swift` 与 `scripts/snug` 生成的 Info.plist 同步。界面状态使用 Combine 的 `ObservableObject` / `@Published`，视图使用 `@ObservedObject`，不再依赖 macOS 14 的 Observation。旧 SDK 下显式标注视图 `@MainActor`。

macOS 14 起保留 ScreenCaptureKit 截图；macOS 13 使用 CoreGraphics 的单窗口原始像素截图。菜单更新角标、数字动画按版本处理；窗口激活使用 Ventura 已有的接口。打包逐架构构建再 `lipo`，避免 SwiftPM 多架构模式依赖 `xcodebuild`。

## 2026-11-18 本机验证

环境：Intel、macOS 13.7.8（22H730），系统只有 Swift 5.8.1 与 Command Line Tools。独立 Swift 6.1.2 工具链和 macOS 14.5 SDK 放在忽略的 `.build/toolchain/`，没有安装到全局。Swift 安装包签名、公证校验通过；SDK 压缩包 sha256 与发布方校验文件一致。

本机复现：

```sh
env PATH="$PWD/.build/toolchain/unpacked/usr/bin:$PATH" \
    SWIFT_EXEC="$PWD/.build/toolchain/unpacked/usr/bin/swiftc-snug" \
    SDKROOT="$PWD/.build/toolchain/MacOSX14.5.sdk" \
    scripts/snug check
```

打包时同样设置环境，执行 `MAC_SIGNING_IDENTITY=- scripts/snug app`。`swiftc-snug` 与 `ld-snug` 是仅供这台旧 Command Line Tools 使用的本地包装器：选择 `/usr/bin/ld`，只过滤旧链接器不认识的 `-no_warn_duplicate_libraries`，其他参数和退出状态原样传递。SDK 镜像展开的 `usr/include/libxml` 重复目录改回指向 `libxml2/libxml` 的符号链接，避免重复模块定义。以上环境均可随 `.build` 删除，重建时需重新准备。

- 原有 337 项测试；新增 3 项 `SnugAppTests/StateObservationTests`，共 340 项通过。临时去掉授权状态通知后回归测试确实失败（4 处断言），恢复后通过。
- 4/4 临时集成检查通过：状态通知、页面切换去重、资源库变更、实际 `NSHostingView` 在模型变更后重新绘图。脚本与结果在 `.build/macos13-state-smoke.*`。
- 6 类界面共 56 张样例渲染成功，输出 `build/macos13-smoke/`。离屏渲染中部分 AppKit 按钮未绘制文字，不能据此判定实际窗口；原生窗口自动检查服务启动失败，实际控件显示尚待确认。
- `--probe-screens` 创建实验屏，540×1170 与 744×1612 两档均成功切到 2 倍模式；SIGINT 收尾后实验屏全部下线，主屏仍为原先的 1792×1120、2 倍、60Hz、原点 (0,0)。日志 `.build/macos13-display-probe.log`。
- `scripts/snug app` 生成 `build/Snug.app`，含 x86_64、arm64，签名校验通过，Info.plist 与 Mach-O 最低版本均为 13.0。已在本机正常启动，读取机型库、监听 UU 推流与检查更新均有日志。
- 未触发：辅助功能未授权，尚未验证实际移窗、手机触控；屏幕录制权限及完整截图流程尚未验证。Apple 芯片和 macOS 14 以上仅完成编译，未在对应系统运行。

构建日志：`.build/macos13-check.log`、`.build/macos13-app.log`；反例日志：`.build/macos13-regression-red.log`。测试版仅本机 ad-hoc 签名，尚未发布或公证。

## 手机资源库一直「正在读取」的后续修复

主人手机实测已能显示手机屏，但 App 资源库一直转圈。16:26 的 UU 系统日志显示，连接开头仅为主屏 2077748985 开推；切到手机屏期间没有新的 SCDisplay 描述或 SCStream 开始事件。旧逻辑一直判断用户在主屏，因此 `PhoneScreenWindows` 没有启动资源库刷新，也会立即关闭搜索页。不能据此断言 App 读取 API 不支持 Ventura。

`CaptureLogWatcher.observation` 在 macOS 13 保留连接活动、选屏返回 nil，不让过期的主屏推断阻止资源库刷新。macOS 14 以上保留原选屏判断。启动日志明确记录兼容策略，资源库首次读取完成后记录运行中 App 数量。代价是 Ventura 无法依据 UU 选屏自动暂停资源库或关闭搜索页。

- 新增 2 项推流观测回归测试，修复前复现 2 处断言失败；修复后 `scripts/snug check` 共 342 项通过。日志 `.build/ventura-spinner-red.log`、`.build/ventura-spinner-check.log`。
- 本机真实 API 与面板集成探针 `.build/ventura-library-probe.swift`：辅助功能已授权；真实建屏、`PhoneScreenWindows` 与 `AppCatalog` 联动。先注入旧主屏观测，1 秒后仍未读取；改为兼容观测后 0.86 秒加载 6 个运行中 App、79 个已安装 App。收尾清空资源库、实验屏下线、主屏编号不变，全部通过；日志 `.build/ventura-library-probe.log`。
- 尚待手机复测：完整 UU 画面、点 App 移窗、搜索与截图。探针验证的是本机真实面板与读取链路，不代替手机端完整操作。
- 已重新构建 Intel/Apple 芯片通用测试包并启动，签名检查通过；启动日志已显示「不推断 UU 当前选屏」「屏 未知」。重打包后辅助功能权限再次失效，须由主人重新授权后手机复测。
