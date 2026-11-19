---
name: project-positioning
description: Snug Intel Mac 独立维护 Intel x86_64、macOS 13+；源自 Snug，保留版权、历史和用户数据兼容
metadata:
  node_type: memory
  type: project
  originSessionId: f97709de-705a-489b-bb7a-7353b1fba51c
  modified: 2026-11-19
---

- 历史来源为 zephyr4123 维护的 Snug，前身为 aoyamashou/UUyc-companion（MIT）。2026-11-19 起由当前仓库独立长期维护 Intel Mac / macOS 13+，不以等待上游 PR 合并为交付路径。
- 版权与致谢必须保留：LICENSE 里 AoyamaShou、zephyr4123 的版权行原样留着；README 和「关于」页写明来源；PermissionFlow、FreeDisplay、Better Remote 等照样致谢。历史记忆中的原项目 issue 不是本仓库 issue。
- 名字 Snug Intel Mac，仓库 https://github.com/boycott96/snug-intel-mac ，默认 `main`，账号 `boycott96`。标识继续使用 `com.zephyr4123.snug`，保留原应用的数据与授权身份；目标为 Intel x86_64，已验证系统 macOS 13.7.8。
- **改动尺度**：保留已有用户数据。更改 `config.json`、`phone-screen.json`、`zoom.json` 的格式要带迁移和回滚路径（红线 6）；历史上游版本的发布记录不等于本仓库已发布。

相关：[[project-release]]
