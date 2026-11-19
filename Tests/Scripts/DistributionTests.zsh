#!/bin/zsh
set -euo pipefail
cd "${0:A:h}/../.."
source <(sed -e '/^cd /d' -e '/^# MARK: 入口/,$d' scripts/snug)

[[ $GH_REPO == boycott96/snug-intel-mac && $REPO_URL == https://github.com/boycott96/snug-intel-mac ]] \
  || die "发布目标不是独立仓库"
[[ ${#ARCHS[@]} == 1 && ${ARCHS[1]} == x86_64 ]] || die "安装包必须只包含 Intel 架构"
print -- "PASS 独立仓库与 Intel 架构"

[[ "$(write_info_plist 2.1.0 | plutil -extract LSMinimumSystemVersion raw -o - -)" == 13.0 ]] \
  || die "最低系统版本不匹配"
[[ "$(write_info_plist 2.1.0 | plutil -extract CFBundleIdentifier raw -o - -)" == com.zephyr4123.snug ]] \
  || die "迁仓不应改变原有授权身份"
print -- "PASS 最低系统与配置身份兼容"

for invalid in '' 'http://example.com/snug-intel-mac' 'https://' 'https:///missing-host' 'https://example.com/path?key=value' \
  'https://dl.zephyrxiang.com/snug' 'https://DL.ZEPHYRXIANG.COM:443/snug' 'https://dl.zephyrxiang.com./snug'; do
  if (
    DOWNLOAD_BASE="$invalid"
    COS_BUCKET="test-bucket"
    COS_REGION="test-region"
    TENCENTCLOUD_SECRET_ID="test-only"
    TENCENTCLOUD_SECRET_KEY="test-only"
    require_cos_setup
  ) > /dev/null 2>&1; then
    die "无效镜像地址未被拒绝：$invalid"
  fi
done
print -- "PASS 8 个无效、未配置或旧项目镜像地址均拒绝"

(
  DOWNLOAD_BASE=""
  unset COS_BUCKET COS_REGION TENCENTCLOUD_SECRET_ID TENCENTCLOUD_SECRET_KEY COS_SECRETS_LOADER COS_CREDENTIAL
  local uploaded=0 published=0 downloads=0
  read_version() { print -- 2.1.0; }
  git() {
    case "$*" in
      'status --porcelain') ;;
      'tag --points-at HEAD') print -- v2.1.0 ;;
      'cat-file -t v2.1.0') print -- tag ;;
      'ls-remote origin refs/tags/v2.1.0^{}') printf 'test-commit\trefs/tags/v2.1.0^{}\n' ;;
      'rev-parse HEAD') print -- test-commit ;;
      *) die "意外 git 命令：$*" ;;
    esac
  }
  check_github_account() { return 0; }
  dist_is_current() { return 0; }
  release_tool() { [[ "$*" == 'feed 2.1.0 dist/2.1.0' ]] || die "意外打包命令"; }
  shasum() { print -- 'test-hash  test-file'; }
  gh() {
    [[ $GH_REPO == boycott96/snug-intel-mac ]] || die "GitHub 发布目标不匹配"
    case "$1 $2" in
      'release view') print -- draft ;;
      'release upload') uploaded=1 ;;
      'release edit') published=1 ;;
      *) die "意外 gh 命令：$*" ;;
    esac
  }
  verify_download() {
    [[ $1 == https://github.com/boycott96/snug-intel-mac/releases/download/v2.1.0/* ]] \
      || die "校验地址不是独立仓库"
    downloads=$((downloads + 1))
  }
  publish_cos() { die "未配置镜像不应上传 COS"; }
  publish_cos_update() { die "未配置镜像不应上传更新清单"; }
  cmd_ship
  [[ $uploaded == 1 && $published == 1 && $downloads == 3 ]] || die "默认发布流程不完整"
)
print -- "PASS 无 COS 配置的 GitHub-only 发布与 3 项下载校验（外部调用已替换）"

(
  DOWNLOAD_BASE="https://example.com/snug-intel-mac/"
  COS_BUCKET="test-bucket"
  COS_REGION="test-region"
  TENCENTCLOUD_SECRET_ID="test-only"
  TENCENTCLOUD_SECRET_KEY="test-only"
  require_cos_setup
  [[ $DOWNLOAD_BASE == https://example.com/snug-intel-mac ]] || die "镜像地址未规范化"
)
print -- "PASS 显式自有镜像配置（未联网上传）"
print -- "5/5 发布配置回归通过"
