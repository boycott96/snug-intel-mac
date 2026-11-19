---
name: project-release
description: 迁仓后发版：boycott96/snug-intel-mac，main；Intel x86_64、macOS 13+；只走 scripts/snug，默认 GitHub；不继承上游签名或公证配置；App 更新仅本仓库 GitHub
metadata:
  node_type: memory
  type: project
  originSessionId: f97709de-705a-489b-bb7a-7353b1fba51c
  modified: 2026-11-19
---

- **当前项目**：唯一入口 https://github.com/boycott96/snug-intel-mac ，默认分支 `main`，GitHub 账号 `boycott96`。长期维护 Intel x86_64、macOS 13+，已在 macOS 13.7.8 验证；App 包只编 x86_64，不构建 arm64 或通用 App 包。
- **一个入口**：构建、测试、打包、公证、发版都走 `scripts/snug`（check / app / install / dist / ship / mirror / media）。新步骤加成子命令或内部函数，不另起脚本。发布流程：把关 → 检查 → 打包（按自有配置签名、公证）→ 上传草稿 → 公开 → 从下载地址核对；断了只补没做完的那一步。
- **签名公证**：不继承上游账号的签名证书、Team ID 或 notarytool 公证档案，也不复用其他项目的凭据。需要签名、公证时，先核验当前维护者自有证书和档案；本记忆不预设它们已配置。敏感配置只放不进 git 的 `.machine.env` 或钥匙串，不能因本机残留旧配置就直接使用。
- **GitHub 账号与仓库**：操作前用 `gh api user --jq .login` 核验当前生效账号必须为 `boycott96`，不符就停止并切换正确账号；不沿用上游专属的 `GH_CONFIG_DIR`。支持仓库参数的 gh 命令一律显式写 `-R boycott96/snug-intel-mac`，调用 API 时显式使用 `repos/boycott96/snug-intel-mac/...`；执行 `scripts/snug` 前也要核验有效仓库配置，不让 remote、upstream 或环境变量把操作导向旧项目。
- **发布目的地**：`ship` 默认只发布本仓库 GitHub Release，无需 COS。只有显式配置自有 `DOWNLOAD_BASE` 和配套 COS 配置时，才额外镜像；不继承上游 COS 桶。镜像不是 App 更新源，详见 [[project-domestic-mirror]]。
- **兼容与溯源**：保留现有 Bundle ID 和用户数据路径，避免破坏授权和设置；迁仓不等于重置应用身份。保留原作者版权、许可证与溯源致谢，不把历史上游 issue 当成本仓库 issue。
- **版本号口径**（主人定）：x.y.0 发主打功能，x.y.z 修 issue 报的问题，即使带一个小入口也算热修复（2.0.1、2.2.1、2.4.1 都是）
- **更新日志口径**：讲用户得到什么（「全面适配所有 App」），不点名具体 App、不讲换分辨率之类的实现。主人通常只审更新日志，其余放手
- **主人的发版习惯**：合并主干、推送、发版前照红线先问。发版后**不替主人装正式版**：由主人从访达重新打开「应用程序」里的旧版（见 [[project-phone-screen]] 的「正式版只让访达开」），自己点「软件更新」。
- **应用内更新**：只从 `boycott96/snug-intel-mac` 的 GitHub 获取更新；历史配置中的 `tencent` 值 fallback 到 `github`，不得再请求旧 CDN，也不因启用自有镜像而改变 App 更新来源。`dist` 用 `snug-release pack` 打 `Snug-<版本>.pack`，`ship` 用标签说明写 `update.json` 并上传 GitHub；只有显式配置自有镜像时才额外复制发布产物。按内容分块、不做需按版本配对的差分补丁；`firstUpdatable` = 2.1.0（Sources/SnugRelease）。
- **更新验证边界**：优先用隔离测试验证 GitHub 仓库指向、旧 `tencent` 配置 fallback、异常路径；不要为测试恢复旧 CDN 配置、向 COS 上传测试文件或覆盖主人现有安装和设置。需要实际更新验证时先取得许可，记录旧版、新版、日志与 Info.plist 结果；本记忆中的 macOS 13.7.8 验证不等同于迁仓后的完整更新链路验证。

可选自有镜像和仓库内 README 媒体见 [[project-domestic-mirror]]
