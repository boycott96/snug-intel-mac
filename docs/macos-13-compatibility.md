# Snug Intel Mac / macOS 13 兼容验证

**兼容性标记：Intel Mac · macOS 13（Ventura）已验证。**

Snug Intel Mac 是面向 **Intel（x86_64）、macOS 13+** 的独立长期维护项目，唯一项目入口为 [boycott96/snug-intel-mac](https://github.com/boycott96/snug-intel-mac)，源码构建使用默认 `main` 分支。历史来源为 [zephyr4123/snug](https://github.com/zephyr4123/snug)，此链接仅作归属，不是本项目下载入口；原作者版权声明与 MIT 许可证保留。

实际运行验证环境为 **Intel（x86_64）、macOS 13.7.8（22H730）**；使用者已确认本机可用。该确认不扩大下文各项测试的覆盖范围，也不代表所有 macOS 13 小版本、机型或更高系统版本均已验证。下文保留历史验证证据，不将其视为后续改动的自动背书。

本仓库尚未发布二进制安装包，推荐从源码构建；唯一发布与更新入口为 [本仓库 GitHub Releases](https://github.com/boycott96/snug-intel-mac/releases)。旧配置中的 `updateSource: "tencent"` 迁移为 `"github"`，不再使用上游 CDN。

## 改动范围

- `de00e35`：替换 macOS 14 的界面观察依赖，使用 Combine 通知界面刷新；为截图、菜单角标与数字动画保留系统版本分支；同步最低系统要求与逐架构打包流程。
- `d6ca4f0`：修复 Ventura 上 UU 选屏日志不完整导致资源库一直「正在读取」的问题。macOS 13 只判断连接活动，当前选屏按未知处理；macOS 14 以上保留原行为。
- Ventura 上不能根据 UU 选屏自动暂停资源库刷新或关闭搜索页，这是 macOS 13 的已知行为差异。

## 验证证据

2026-11-18 的本机记录：

- 原有 337 项测试，新增 3 项状态通知测试与 2 项推流观测测试，共 **342 项通过**。临时移除通知及还原旧选屏判断时，新增测试分别复现失败。
- **4/4** 集成检查通过：状态通知、页面切换去重、资源库变更、实际 `NSHostingView` 随模型变更重新绘图。
- 6 类界面共 **56 张**样例渲染成功；部分离屏 AppKit 按钮未绘制文字，因此不将样例渲染视为实际控件显示全部通过。
- 真实创建虚拟屏，540×1170、744×1612 两档均成功切到 2 倍模式；退出后实验屏全部下线，主屏配置恢复。
- 真实 API 与资源库面板集成探针：旧主屏观测下 1 秒后仍未读取，兼容观测下 0.86 秒加载 6 个运行中 App、79 个已安装 App；收尾撤屏、清空资源库，主屏编号不变。
- 当时的历史测试包包含 x86_64、arm64，Info.plist 与 Mach-O 最低版本均为 13.0；本机 ad-hoc 签名检查通过，并已启动。这是历史产物记录，不是本项目提供通用安装包或支持 Apple 芯片运行的承诺。

本地原始日志保留在忽略的 `.build/`，未作为公共仓库附件提交：`macos13-check.log`、`ventura-spinner-check.log`、`macos13-state-smoke.log`、`macos13-display-probe.log`、`ventura-library-probe.log`、`macos13-app.log`；反例日志为 `macos13-regression-red.log`、`ventura-spinner-red.log`。

2026-11-19 提交前再次执行下节的 `scripts/snug check`：全部产物构建通过，**342/342 项测试通过**。真实输出为 `Test run with 342 tests passed after 2.501 seconds.`，日志为 `.build/macos13-pr-check.log`。本轮未重新执行界面渲染、建屏探针或手机端操作，不将历史验证记为本轮复测。

### 2026-11-19 独立仓库迁移验证

- 更新源与配置迁移的 9 项定向测试先在旧实现上复现 **8 处断言失败**，覆盖默认源、旧 `tencent` 配置、可选源列表及仓库 URL；日志 `.build/intel-repo-red.log`。
- 迁移后执行 `scripts/snug check`：全部产物构建通过，**343/343 项 Swift 测试通过**，末行为 `Test run with 343 tests passed after 2.631 seconds.`；日志 `.build/intel-repo-check.log`。
- **5/5 组发布配置回归通过**：本仓库目标和 Intel 架构、最低系统及 Bundle ID、8 个无效/未配置/旧项目镜像地址、无 COS 的默认 GitHub 发布、自有镜像配置。发布与下载外部调用已在测试中替换，未实际创建 Release、下载发布包或上传 COS；测试纳入 `scripts/snug check`。独立复审发现显式配置仍可能误用旧 CDN，补充负例先复现失败，再加入域名阻断；反例日志 `.build/intel-mirror-red.log`。
- `MAC_SIGNING_IDENTITY=- scripts/snug app` 成功生成本机测试包；`lipo -archs` 真实输出仅为 `x86_64`，Info.plist 最低版本为 `13.0`，`codesign --verify --strict --deep` 退出码为 0。日志 `.build/intel-repo-app.log`。没有安装、启动或发布此新包，也未做公证。
- README 的 **14/14** 个媒体文件与文件名 SHA-256 前 8 位匹配，文档及图片的 **59/59** 个本地链接可定位。
- 本轮没有复测手机完整操作、界面渲染、虚拟屏建撤或实际跨版本自动更新；这些场景仍维持上述验证边界。

## 复现

构建要求为 Swift 6.1 或更新版本，以及 macOS 14 或更新的 SDK。本机工具链与 SDK 均隔离在 `.build/toolchain/`，不修改全局开发环境：

```sh
env PATH="$PWD/.build/toolchain/unpacked/usr/bin:$PATH" \
    SWIFT_EXEC="$PWD/.build/toolchain/unpacked/usr/bin/swiftc-snug" \
    SDKROOT="$PWD/.build/toolchain/MacOSX14.5.sdk" \
    scripts/snug check
```

上述路径及 `swiftc-snug` 是本机验证环境，不随仓库分发。旧版 Command Line Tools 的链接器兼容处理见 [本机环境记录](../.memory/project-macos13.md)；其他开发环境按 [开发说明](development.md) 配置工具链。

## 验证边界与维护范围

- 历史验证中 Apple 芯片与 macOS 14 以上仅完成编译，未在对应硬件或系统运行。Apple 芯片不在本项目目标范围内；macOS 14 及以上仍需独立运行验证。
- 手机端完整 UU 操作、点 App 移窗、搜索与截图没有逐项复测记录；使用者确认可用不替代这些场景的独立证据。
- ad-hoc 重签后可能需要重新授予辅助功能权限。历史测试包未发布、未公证；本项目不作 Apple 签名或公证承诺。尚无本仓库发布包的端到端更新验证，当前通过源码构建更新。
- 历史兼容改动基于 `9710d59`，关键改动提交见上文；后续由本仓库独立维护，新增变更须追加对应验证证据。
