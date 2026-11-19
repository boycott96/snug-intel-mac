---
name: project-domestic-mirror
description: 迁仓后默认 GitHub，仅显式自有 DOWNLOAD_BASE 与 COS 配置才额外镜像；README 14 张素材在 Assets/README，文件名 sha256 前 8 位已核验；保留通用截图与录屏规格
metadata:
  node_type: memory
  type: project
  originSessionId: f97709de-705a-489b-bb7a-7353b1fba51c
  modified: 2026-11-19
---

2026-11-19 迁仓后基线：唯一项目入口 https://github.com/boycott96/snug-intel-mac ，默认分支 `main`，账号 `boycott96`。本文件替代迁仓前国内源与媒体托管操作指引，不沿用旧账号、域名、证书续期或桶配置。

**GitHub 默认与可选自有镜像**
- **默认发布**：只走 `scripts/snug ship`，默认发布 `boycott96/snug-intel-mac` 的 GitHub Release，无需 COS，不要求国内 CDN。App 更新只走本仓库 GitHub，旧 `tencent` 配置 fallback 到 `github`。
- **显式启用**：只有维护者显式配置自有 `DOWNLOAD_BASE` 和配套 COS 配置时，`ship` 才额外镜像发布产物。`mirror <版本>`、`media <文件…>` 也只可在确认自有配置后使用，不能把本机旧配置当授权；默认 README 媒体无需上传。
- **隔离与权限**：不继承上游 COS 桶、域名、签名证书或公证档案，不共用其他项目的凭据、流量配额或统计缓存。自有凭据放不进 git 的 `.machine.env`，权限按最小给；未配置就保持 GitHub 默认，不为发版补旧配置。
- **镜像边界**：镜像仅作额外下载副本，不作为 App 更新源。版本产物保持不可变，上传前后核对 sha256；不得用镜像覆盖本仓库 GitHub 的更新入口。
- **看下载量**（主人问了才查）：用本仓库 releases API 的 `download_count`，API 路径显式指定 `repos/boycott96/snug-intel-mac/releases`；计数可能含发版核对下载，不宣称为去重用户数。未配置自有镜像就不查国内源统计。

**README**（中英文两份一起改，默认使用仓库内媒体）
- **素材归属**：README 14 张素材已复制至 `Assets/README`，文件名中的 sha256 前 8 位已核验。使用仓库内相对路径，新增或替换素材也核对文件名指纹，不恢复旧 CDN 链接；保留版权溯源与致谢。
- **结构**：主线是原生体验（竖屏原生显示、原生手势），放最前；App 资源库、适配所有 App 与手机是它的延伸，别写成工作台。安卓按「全面支持」写，主人定的，不收窄。Star 趋势如保留，亮暗两版可用 `<picture>` 切换，目标必须是 `boycott96/snug-intel-mac`；不因图表服务异常恢复旧媒体托管。
- **演示替换**：新演示素材参照 [[project-demo-recording]]，替换前核对当前画面与产品版本，不把迁仓前的录制进度当成已验证现状。
- **GitHub 的限制**：会删掉 `<video>`，录屏用 animated WebP，完整 MP4 用链接给（链接不走代理，没有大小限制）。外链图片一律经 GitHub 图片代理，大小上限在代理：开源 camo 默认 5 MiB，4.97 MB 实测能取到。代理原样转发字节，不会再压缩
- **动图体积**几乎全花在整屏滚动的帧上（每帧约 50 KB，打字、弹键盘的帧约 7 KB）；超了先用 img2webp 逐帧 `-q` 只降滚动段，宽度 540 在 README 30% 宽下看不出差别
- **录屏打码**：按字符范围定位（Vision `boundingBox(for:)`），只糊「用户名@机器名」那一截，敲的命令照常露出；逐帧识别复查，并拿没打码的原画做正对照
- **手机截图**：17 Pro Max 原图 1320×2868，顶部 273 行是黑边，裁成 `crop=1320:2595:0:273,pad=1320:2598:0:0:black`（ffmpeg，sips 裁不动），和旧图一样 1320×2598，否则并排时高度对不齐
- **Mac 端截图**不用主人截，渲染样例：设置页用 `.build/debug/Snug --render-settings <目录>`；欢迎页、关于页用装好的正式版渲染（`/Applications/Snug.app/Contents/MacOS/Snug --render-about <目录>`），因为调试版不在 App 包里，图标会变成文件夹、版本显示「开发版」。渲染参数在启动最前面处理完就退出，不碰正在跑的那份。安装一节三张并排（欢迎页、设置、关于），都补到 1040×1096（设置、关于用同色 f6f6f6 上下补边）

相关：[[project-release]]
