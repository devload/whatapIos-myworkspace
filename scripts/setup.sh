#!/bin/bash
# WhaTap iOS Workspace 개발환경 초기 세팅
# Usage: ./scripts/setup.sh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'
log() { echo -e "${BLUE}[SETUP]${NC} $1"; }
ok()  { echo -e "${GREEN}[OK]${NC} $1"; }
skip() { echo -e "${YELLOW}[SKIP]${NC} $1"; }
err() { echo -e "${RED}[ERR]${NC} $1"; }

WORKSPACE="$(cd "$(dirname "$0")/.." && pwd)"
cd "$WORKSPACE"

echo ""
echo "========================================="
echo "  WhaTap iOS Workspace Setup"
echo "========================================="
echo ""

# 1. Submodules
log "Git submodules 초기화 (14개)..."
git submodule init 2>/dev/null
git submodule update --recursive
ok "Submodules 준비 완료"

# 2. Xcode CLI Tools 확인
log "Xcode Command Line Tools 확인..."
if xcode-select -p &>/dev/null; then
  XCODE_PATH=$(xcode-select -p)
  ok "Xcode CLI Tools: $XCODE_PATH"
else
  err "Xcode Command Line Tools 미설치. xcode-select --install 실행 필요"
fi

# 3. CocoaPods 확인
if command -v pod &>/dev/null; then
  ok "CocoaPods: $(pod --version)"
else
  skip "CocoaPods 미설치 — brew install cocoapods 또는 gem install cocoapods"
fi

# 4. Node.js 프로젝트 의존성 설치
NODE_PROJECTS=(
  "demo-generator"
  "whatap-mobile-proxy-server"
)

log "Node.js 프로젝트 의존성 설치..."
for proj in "${NODE_PROJECTS[@]}"; do
  if [ -f "$proj/package.json" ]; then
    log "  $proj..."
    cd "$proj" && npm install --silent 2>/dev/null && cd "$WORKSPACE"
    ok "  $proj"
  else
    skip "  $proj (package.json 없음)"
  fi
done

# 5. Rust 프로젝트 (atosw-rust)
if command -v cargo &>/dev/null; then
  if [ -f "atosw-rust/Cargo.toml" ]; then
    log "atosw-rust 빌드 확인..."
    cd atosw-rust && cargo check --quiet 2>/dev/null && cd "$WORKSPACE"
    ok "atosw-rust"
  fi
else
  skip "Rust 미설치 — atosw-rust 건너뜀 (curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh)"
fi

# 6. Scripts 실행 권한
log "스크립트 실행 권한 설정..."
chmod +x scripts/*.sh
ok "스크립트 준비 완료"

echo ""
echo "========================================="
echo "  Setup 완료!"
echo "========================================="
echo ""
echo "  워크스페이스: $WORKSPACE"
echo ""
echo "  서브모듈 ($(git submodule status | wc -l | tr -d ' ')개):"
git submodule status | while read -r line; do echo "    $line"; done
echo ""
echo "  카테고리:"
echo "    iOS Agent:        iosAgent, WhatapIOSAgent-Release"
echo "    Mobile Spec:      whatap-mobile-agent-spec"
echo "    Symbolication:    atosw, atosw-rust, atosw-kotlin, whatap-stack-repository"
echo "    Testing & QA:     whatap-ios-qa-guide, ios-sample-apps, webview-sample-ios-whatap,"
echo "                      ios-simulator-tools, ios-device-list"
echo "    Tools:            demo-generator, whatap-mobile-proxy-server"
echo "    로컬:             docs/"
echo ""
echo "  다음 단계:"
echo "    - iOS Agent 빌드: cd iosAgent && make build"
echo "    - 시뮬레이터 테스트: /sim-run (Claude Code)"
echo "    - 프록시 서버: cd whatap-mobile-proxy-server && npm start"
echo ""
