# Intel Mac / macOS 13 兼容验证

**兼容性标记：Intel Mac · macOS 13（Ventura）已验证。**

本贡献分支将最低运行版本降为 macOS 13，保留 Intel 与 Apple 芯片的通用构建。实际运行验证环境为 **Intel（x86_64）、macOS 13.7.8（22H730）**；使用者已确认本机可用。该确认不扩大下文各项测试的覆盖范围，也不代表所有 macOS 13 小版本或机型均已验证。

## 改动范围

- `de00e35`：替换 macOS 14 的界面观察依赖，使用 Combine 通知界面刷新；为截图、菜单角标与数字动画保留系统版本分支；同步最低系统要求与逐架构打包流程。
- `d6ca4f0`：修复 Ventura 上 UU 选屏日志不完整导致资源库一直「正在读取」的问题。macOS 13 只判断连接活动，当前选屏按未知处理；macOS 14 以上保留原行为。
- Ventura 上不能根据 UU 选屏自动暂停资源库刷新或关闭搜索页，这是兼容分支的已知行为差异。

## 验证证据

2026-11-18 的本机记录：

- 原有 337 项测试，新增 3 项状态通知测试与 2 项推流观测测试，共 **342 项通过**。临时移除通知及还原旧选屏判断时，新增测试分别复现失败。
- **4/4** 集成检查通过：状态通知、页面切换去重、资源库变更、实际 `NSHostingView` 随模型变更重新绘图。
- 6 类界面共 **56 张**样例渲染成功；部分离屏 AppKit 按钮未绘制文字，因此不将样例渲染视为实际控件显示全部通过。
- 真实创建虚拟屏，540×1170、744×1612 两档均成功切到 2 倍模式；退出后实验屏全部下线，主屏配置恢复。
- 真实 API 与资源库面板集成探针：旧主屏观测下 1 秒后仍未读取，兼容观测下 0.86 秒加载 6 个运行中 App、79 个已安装 App；收尾撤屏、清空资源库，主屏编号不变。
- 测试包包含 x86_64、arm64，Info.plist 与 Mach-O 最低版本均为 13.0；本机 ad-hoc 签名检查通过，并已启动。

本地原始日志保留在忽略的 `.build/`，未作为公共仓库附件提交：`macos13-check.log`、`ventura-spinner-check.log`、`macos13-state-smoke.log`、`macos13-display-probe.log`、`ventura-library-probe.log`、`macos13-app.log`；反例日志为 `macos13-regression-red.log`、`ventura-spinner-red.log`。

2026-11-19 提交前再次执行下节的 `scripts/snug check`：全部产物构建通过，**342/342 项测试通过**。真实输出为 `Test run with 342 tests passed after 2.501 seconds.`，日志为 `.build/macos13-pr-check.log`。本轮未重新执行界面渲染、建屏探针或手机端操作，不将历史验证记为本轮复测。

## 复现

构建要求为 Swift 6.1 或更新版本，以及 macOS 14 或更新的 SDK。本机工具链与 SDK 均隔离在 `.build/toolchain/`，不修改全局开发环境：

```sh
env PATH="$PWD/.build/toolchain/unpacked/usr/bin:$PATH" \
    SWIFT_EXEC="$PWD/.build/toolchain/unpacked/usr/bin/swiftc-snug" \
    SDKROOT="$PWD/.build/toolchain/MacOSX14.5.sdk" \
    scripts/snug check
```

上述路径及 `swiftc-snug` 是本机验证环境，不随仓库分发。旧版 Command Line Tools 的链接器兼容处理见 [本机环境记录](../.memory/project-macos13.md)；其他开发环境按 [开发说明](development.md) 配置工具链。

## 验证边界与提交状态

- Apple 芯片与 macOS 14 以上仅完成编译，未在对应硬件或系统运行。
- 手机端完整 UU 操作、点 App 移窗、搜索与截图没有逐项复测记录；使用者确认可用不替代这些场景的独立证据。
- ad-hoc 重签后可能需要重新授予辅助功能权限。测试包未发布、未公证，官方安装包不能据此宣称支持 macOS 13。
- 本分支基于 `9710d59`。2026-11-19 核对时，上游 `main` 为 `43c9e24`，已进行多屏重构；合并预检存在多处冲突。应以草稿 PR 讨论并迁移兼容改动，不能直接宣称可合并，也不沿用本记录为迁移后的代码背书。
