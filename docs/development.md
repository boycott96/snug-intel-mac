# 开发

本项目为 Intel Mac / macOS 13+ 的独立长期维护版本，项目、问题反馈及发布入口统一为 [boycott96/snug-intel-mac](https://github.com/boycott96/snug-intel-mac)。默认分支为 `main`，不依赖上游 PR 合并。

## 构建与发布

构建、测试、打包与发布统一由 `scripts/snug` 完成（`scripts/snug help` 查看全部命令）。

| 命令 | 作用 |
| :--- | :--- |
| `scripts/snug check` | 发布配置回归 → 构建全部产物 → 全部 Swift 测试；任一步骤失败即以非零状态退出 |
| `scripts/snug app` | 生成 `build/Snug.app`（Intel x86_64）并签名 |
| `scripts/snug install` | 生成 App、安装至「应用程序」并打开；正在运行的 Snug 会先正常退出，窗口先行归位 |
| `scripts/snug dist` | 生成可分发的 `dist/<版本>/Snug-<版本>.dmg`：Developer ID 签名，App 与 dmg 分别公证并装订票据；再将公证后的 App 打成应用内更新用的 `Snug-<版本>.pack` |
| `scripts/snug ship` | 发布：前置检查 → check → dist → 生成 `update.json` → 创建本仓库 GitHub Release 草稿并上传 → 公开 → 下载核对；不要求 CDN |
| `scripts/snug mirror <版本>` | 可选：将已公开的版本补传至自己配置的镜像，须显式设置 `DOWNLOAD_BASE` 和 COS 配置 |
| `scripts/snug media <文件…>` | 可选：将图片、视频上传至自有镜像，须显式设置 `DOWNLOAD_BASE`；README 默认使用仓库内图片 |

**运行要求**：Intel Mac（x86_64）、macOS 13 或更新版本。打包只生成 Intel 架构，不承诺 Apple 芯片运行支持。

**已验证环境**：Intel Mac（x86_64）、macOS 13.7.8（22H730）。使用者已确认本机可用；自动化证据、复现命令及未覆盖范围见 [macOS 13 兼容验证](macos-13-compatibility.md)。其他系统版本须单独验证。

macOS 13 上，UU 切屏时的推流日志不能可靠反映当前选屏，因此只用日志判断连接活动，选屏按未知处理；手机屏资源库保持刷新。macOS 14 及更新版本继续在离开手机屏时暂停列表刷新、关闭搜索页。

**构建要求**：Swift 6.1 或更新版本、macOS 14 或更新的 SDK（用于编译带版本保护的新版接口）。可使用 Xcode，或命令行工具搭配独立 Swift 工具链与 SDK；通过 `PATH` 选择 Swift、`SDKROOT` 选择 SDK，无需升级运行系统。测试使用 Swift Testing，不依赖 XCTest；安装包显式编译为 x86_64。

旧版命令行工具的链接器可能不支持 Swift 6 默认传入的 `-no_warn_duplicate_libraries` 参数；应搭配新版链接器。本机 macOS 13 的隔离验证环境与复现命令见 [兼容验证记录](../.memory/project-macos13.md)。

**签名**：钥匙串中有唯一一张「Developer ID Application」证书时自动使用；否则采用 ad-hoc 签名，此时每次重新构建后都需要重新授权辅助功能。

**身份与配置迁移**：保留原有 Bundle ID（`com.zephyr4123.snug`）、`Snug.app` 文件名和用户数据路径，避免仅迁仓就丢失设置或改变授权身份；不应与原版同时运行。默认更新源为本仓库 GitHub，旧配置中的 `tencent` 与未知更新源回退为 `github`，保存配置时写回新值；从此不再自动取用上游安装包。回滚前备份 `~/Library/Application Support/Snug/`，回滚可恢复此前提交构建的 App 和备份设置，不改写原有用户数据结构。

**发布流程**

1. 修改并提交仓库根目录的 `VERSION`（版本号只记录在这里）
2. 打上带说明的同名标签并推送：`git tag -a v2.0.0 -m "…"`。Release 的说明与 App 内的更新日志都取自标签说明：第一行去掉「Snug <版本>：」后作为标题；正文中的「安装」一节只出现在 Release 上
3. 执行 `scripts/snug ship`

- 已发布的版本不再更改：GitHub 上已公开、而本机的安装包与之不同时，发布会被拒绝，需提升版本号
- `ship` 中断后可直接重新执行，`dist/<版本>/` 中出自同一提交的安装包会被复用；可选自有镜像上已有且内容一致的文件会跳过

**本机配置**存放在不纳入版本控制的 `.machine.env`（模板为 `.machine.env.example`），只记录名称，不存放密钥：

| 键 | 含义 |
| :--- | :--- |
| `MAC_SIGNING_IDENTITY` | 签名证书；`-` 表示 ad-hoc |
| `MAC_NOTARY_PROFILE` | `xcrun notarytool store-credentials` 存储的公证档案名 |
| `GH_CONFIG_DIR` / `GITHUB_ACCOUNT` | 发布所用的 GitHub 账号 |
| `DOWNLOAD_BASE` | 可选自有 CDN 的 HTTPS 根地址（含 `snug-intel-mac` 对象前缀），留空时不使用 CDN |
| `COS_BUCKET` / `COS_REGION` | 国内源所在的 COS 桶与地域 |
| `COS_CREDENTIAL` / `COS_SECRETS_LOADER` | 腾讯云密钥的凭据名与按需加载器（提供 `withkey`）；环境中已有 `TENCENTCLOUD_SECRET_ID` / `TENCENTCLOUD_SECRET_KEY` 时可留空 |

## 可选自有镜像

默认仅发布至 [本仓库 GitHub Releases](https://github.com/boycott96/snug-intel-mac/releases)，没有原项目 CDN 依赖；应用内也只提供 GitHub 更新源。若后续需要镜像，可在 `.machine.env` 显式配置自己的 `DOWNLOAD_BASE`、COS 桶和凭据，`ship` 才额外同步，`mirror` / `media` 才能使用。镜像对象前缀为 `snug-intel-mac`；不能沿用原项目的桶或 CDN。

| 路径 | 内容 | 缓存 |
| :--- | :--- | :--- |
| `v<版本>/Snug-<版本>.dmg`、`.sha256` | 各版本安装包，发布后不再更改 | 一年 |
| `v<版本>/Snug-<版本>.pack`、`update.json` | 应用内更新所用的分块包及其说明（见下文「应用内更新」） | 一年 |
| `latest/Snug.dmg` | 固定的最新版下载地址（README 与官网使用），只向更新的版本切换，下载文件名带版本号 | 5 分钟 |
| `latest/update.json` | 可选镜像的更新清单备份；App 仍只从本仓库 GitHub 检查更新 | 5 分钟 |
| `media/<名称>.<指纹>.<后缀>` | README 的图片与视频，内容变化时地址随之变化 | 一年 |

- 每个对象记录 sha256：重复上传时内容一致即跳过，不一致即拒绝
- 上传使用的 Python 环境位于仓库内的 `.venv`（不纳入版本控制），依赖版本锁定在 `scripts/cos-requirements.txt`，缺失时自动安装
- README 的图片与动图位于 `Assets/README/`，保留上游素材归属，不再依赖外部媒体 CDN

## 应用内更新

每个版本在本仓库 GitHub Release 额外发布两个文件（如配置了自有镜像，可同步备份）：

- `Snug-<版本>.pack`：将 App 按内容切块（FastCDC，平均 128 KiB），去重后逐块 LZMA 压缩，首尾相接
- `update.json`：版本号、2.1.0 以来各版本的更新日志，以及清单（每块在包中的位置、每个文件由哪几块组成）

App 将本机已安装的 Snug 按同样方式切块，只按字节范围从最新的包中读取本机缺少的块，因此从任何旧版本都能直接升到最新版，无需逐版本的补丁。格式与打包逻辑位于 `SnugCore/Update`，发布工具 `snug-release`（`Sources/SnugRelease`）与 App 共用同一份实现：`dist` 时打包，并照清单拼装、核对签名，通过后才交出；`ship` 时生成 `update.json`。

## 代码结构

代码分为三层，依赖单向向下：

| 目标 | 内容 |
| :--- | :--- |
| `SnugCore` | 纯逻辑：连接判定与会话、手机屏调度 `PhoneDesk`、屏幕适配 `ScreenFit`、手势翻译 `TouchTranslator`、截图 `Screenshots`、规格、还原记录、配置、日志、启动参数、更新包格式。系统能力抽象为协议，测试中使用假实现 |
| `SnugSystem` | 系统层：`CGVirtualDisplay` 建屏与撤屏、辅助进程切换分辨率档位、辅助功能接口移动窗口、按进程发送字号快捷键、手势事件监听 `TouchTap`、ScreenCaptureKit 截图 |
| `Snug` | 应用层：UU远程 感知、AppController、应用内更新 `Updater`、手机屏上的 App 资源库、指示条与截图裁剪、设置（通用、关于）、欢迎页、菜单栏 |

发布工具 `SnugRelease` 只依赖 `SnugCore`，由 `scripts/snug` 调用。

手势翻译分两半：`SnugCore/Touch` 是纯状态机，只认一块范围 `TouchRegion`（位置与缩放倍数），不依赖手机屏；`SnugSystem` 中 `TouchTap` 负责监听线程，`TouchEvents` 负责读入与拼装事件。`AppController` 只决定范围：手机屏在、开着手势且没在裁剪截图时为手机屏，否则关闭。新增一种手势时，在状态机里加判定与 `TouchCommand`，在 `TouchEvents` 里拼装要补发的事件，再在 `TouchTap` 按命令分派处补上一支。

## 启动参数

参数有误时会打印用法。

| 参数 | 作用 |
| :--- | :--- |
| `--render-<界面> <目录>` | 将界面渲染为 PNG：`settings` / `welcome` / `about` / `legacy` / `phone` / `update`（不启动监控，不改动屏幕） |
| `--preview-phone` | 正常启动，但不等待手机连接即创建手机屏，无需手机即可查看屏上的列表（**会真实创建一块屏幕**） |
| `--dump-uu` | 打印从 UU远程 读取到的界面（文字、表格与行）、认出的控制端与当前屏幕 |
| `--probe-screens <规格…>` | 实测用（多屏方案的 V1～V12，见 [multi-screen.md](multi-screen.md)）：每份规格建一块实验屏，打印各档模式与 2 倍是否可用，按 Ctrl-C 撤屏并还原排布。规格是逗号分隔的 `键=值`：`modes=宽x高+…`（必填）、`name`、`serial`（默认用 999000001 起的实验身份）、`cap=像素宽x像素高`、`pattern=on\|off`（校准图）、`main=on`（设为主屏，最多一块）。**会真实创建屏幕**，测试时随测随撤，免得指针跑到看不见的屏上 |
| `--set-mode <屏幕编号> <宽> <高>` | 辅助进程模式：将手机屏切换至该档的 2 倍模式后立即退出（供主程序内部调用；高由主程序按手机型号的比例算好传入） |
| `--restore-mode <屏幕编号> <模式编号> <宽> <高> <像素宽> <像素高> <刷新率> session\|permanent` | 辅助进程模式：将一块屏幕设回该模式后立即退出，只对当前登录生效或连同永久配置（供主程序内部调用：创建、移除手机屏时被系统改变模式的屏幕） |

## 数据与日志

| 位置 | 内容 |
| :--- | :--- |
| `~/Library/Application Support/Snug/config.json` | 设置 |
| `~/Library/Application Support/Snug/phone-screen.json` | 手机屏上窗口的还原记录 |
| `~/Library/Application Support/Snug/zoom.json` | 各 App 记忆的字号级数 |
| `~/Library/Application Support/Snug/left-behind.json` | 在 Snug 之外关闭的窗口待还原的位置与字号（保留两周） |
| `~/Library/Logs/Snug.log` | 日志 |

实现细节见 [工作原理](how-it-works.md)。
