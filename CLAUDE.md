# WhaTap iOS Workspace

이 워크스페이스는 WhaTap iOS 모니터링 관련 14개 프로젝트를 git submodule로 통합 관리하는 개발 환경입니다.
iOS Agent SDK, Crash Symbolication (atosw), QA/테스트, 도구 프로젝트 포함.

## 프로젝트 구조

```
whatapIos-myworkspace/
├── # iOS Agent SDK
├── iosAgent/                      (whatap) iOS Agent 소스 (Obj-C/Swift)
├── WhatapIOSAgent-Release/        (whatap) iOS Agent 릴리즈 XCFramework
│
├── # Mobile Spec
├── whatap-mobile-agent-spec/      (whatap) 모바일 Agent 프로토콜 스펙
│
├── # Crash Symbolication
├── atosw/                         (whatap) iOS Crash Symbolication Hub
├── atosw-rust/                    (whatap) dSYM → .atosw 변환기 (Rust)
├── atosw-kotlin/                  (whatap) .atosw Reader & Service (Kotlin)
├── whatap-stack-repository/       (whatap) Stack Trace 디코딩 서비스
│
├── # Testing & QA
├── whatap-ios-qa-guide/           (devload) iOS QA 가이드 문서
├── ios-sample-apps/               (devload) iOS 샘플 앱 모음
├── webview-sample-ios-whatap/     (devload) WebView 모니터링 샘플
├── ios-simulator-tools/           (devload) 시뮬레이터 제어 도구
├── ios-device-list/               (devload) Apple 디바이스 목록
│
├── # Tools
├── demo-generator/                (whatap) Mock 데이터 생성
├── whatap-mobile-proxy-server/    (whatap) 모바일 SDK 프록시 서버
│
├── docs/                          (로컬) 통합 문서
├── scripts/                       유틸리티 스크립트
└── .claude/commands/              Claude Code slash commands
```

## 주의사항

- whatap org 레포는 push 시 조직 권한 필요
- devload 레포는 개인 소유 — 자유롭게 push 가능
- `docs/`는 submodule이 아닌 일반 디렉토리
- 새 프로젝트 추가: `git submodule add https://github.com/{org}/{repo}.git {name}`

## iOS Agent 개발 환경

### 빌드 환경 요구사항

| 도구 | 버전 | 용도 |
|------|------|------|
| Xcode | 15+ | iOS Agent 빌드, 샘플 앱 |
| Swift | 5.9+ | iOS Agent SDK |
| CocoaPods | latest | 의존성 관리 |
| Rust | latest | atosw-rust (dSYM 변환기) |
| Node.js | 18+ | demo-generator, proxy-server |
| Java | 17 | atosw-kotlin, whatap-stack-repository |

### iOS Agent 빌드

```bash
cd iosAgent
# Makefile 기반 빌드
make build        # 빌드
make clean        # 클린 빌드

# 또는 Xcode
xcodebuild -project WhatapAgent.xcodeproj -scheme WhatapAgent -configuration Release
```

### 릴리즈 바이너리

```
WhatapIOSAgent-Release/
├── WhatapAgent.xcframework     ← 최종 배포 바이너리
├── WhatapAgent.podspec         ← CocoaPods 배포 스펙
└── Package.swift               ← SPM 배포 스펙
```

### dSYM Symbolication 플로우

```
1. Xcode Archive → dSYM 파일 추출
2. atosw-rust: dSYM → .atosw 변환 (경량화)
   $ cd atosw-rust && cargo run -- convert /path/to/app.dSYM -o output.atosw
3. atosw-kotlin: .atosw 파일 기반 주소 → 심볼 변환
4. whatap-stack-repository: REST API로 디코딩 서비스 제공
```

### 시뮬레이터 테스트

```bash
# 사용 가능한 시뮬레이터 목록
xcrun simctl list devices available

# 샘플 앱 빌드 & 실행 (시뮬레이터)
cd ios-sample-apps/<app-name>
xcodebuild -project *.xcodeproj -scheme <scheme> \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

# WhatAp 로그 확인
xcrun simctl spawn booted log stream --predicate 'subsystem == "io.whatap"' --level debug
```

### 프록시 서버 (데이터 전송 테스트)

```bash
cd whatap-mobile-proxy-server
npm install && npm start
# http://localhost:6600 에서 프록시 서버 실행
# iOS Agent의 서버 주소를 프록시로 변경하여 데이터 확인 가능
```

## Claude Code Slash Commands

| 명령어 | 설명 |
|--------|------|
| `/build-agent` | iOS Agent 빌드 (debug/release/clean) |
| `/sim-run` | 시뮬레이터에서 샘플 앱 빌드 & 실행 |
| `/sim-logs` | 시뮬레이터/디바이스 WhatAp 관련 로그 확인 |
| `/dsym-convert` | dSYM → .atosw 변환 |
| `/worktree-status` | Git worktree 상태 확인 |
| `/proxy-server` | 모바일 프록시 서버 시작/중지 |
