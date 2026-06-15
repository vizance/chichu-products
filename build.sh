#!/usr/bin/env bash
#
# build.sh — 把 source/early-bird.html 用 StaticCrypt 整份加密，
#            產生部署用的加密版 early-bird.html（根目錄）。
#
# 用法：
#   ./build.sh '密碼'            # 直接帶密碼
#   ./build.sh                   # 會提示輸入密碼
#
# 改內容流程：改 source/early-bird.html → 重跑這支 → git push。
# 注意：source/ 是明文、已 gitignore、不公開，請自行備份。
#
set -euo pipefail
cd "$(dirname "$0")"

PASSWORD="${1:-${STATICRYPT_PASSWORD:-}}"
if [ -z "$PASSWORD" ]; then
  read -rsp "輸入密碼: " PASSWORD; echo
fi

echo "→ StaticCrypt 加密 source/early-bird.html ..."
npx -y staticrypt source/early-bird.html \
  -p "$PASSWORD" \
  -d build/enc \
  --remember 30 \
  --short \
  --template-title "朱騏 早鳥價對照表（內部）" \
  --template-instructions "本頁為內部定價資料，請輸入密碼後觀看。" \
  --template-placeholder "請輸入密碼" \
  --template-button "進入" \
  --template-remember "記住我（30 天內免重新輸入）" \
  --template-error "密碼錯誤，請再試一次" \
  --template-color-primary "#e8732c" \
  --template-color-secondary "#2b2b2b"

cp build/enc/early-bird.html early-bird.html
echo "✓ 完成：根目錄 early-bird.html 已更新為加密版"
