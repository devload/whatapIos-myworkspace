# WhaTap iOS Workspace

WhaTap iOS 모니터링 관련 프로젝트 통합 개발 환경. 14개 서비스를 git submodule로 관리합니다.

## Quick Start

```bash
# 클론 (submodule 포함)
git clone --recursive https://github.com/devload/whatapIos-myworkspace.git
cd whatapIos-myworkspace

# 초기 세팅
./scripts/setup.sh
```

## 아키텍처

```
iOS App → WhatapAgent (iosAgent) → WhaTap Server
                                       ↕
              atosw-rust (dSYM → .atosw) → atosw-kotlin (symbolication service) → whatap-stack-repository
```

## 프로젝트 구조

```
whatapIos-myworkspace/
│
├── # ── iOS Agent SDK ──────────────────────────────
├── iosAgent/                      ← iOS Agent SDK 소스 (whatap)
├── WhatapIOSAgent-Release/        ← iOS Agent 릴리즈 바이너리 (whatap)
│
├── # ── Mobile Spec & Protocol ─────────────────────
├── whatap-mobile-agent-spec/      ← 모바일 Agent 데이터 전송 프로토콜 스펙 (whatap)
│
├── # ── Crash Symbolication (atosw) ────────────────
├── atosw/                         ← iOS Crash Symbolication Hub (whatap)
├── atosw-rust/                    ← dSYM → .atosw 변환기 - Rust CLI (whatap)
├── atosw-kotlin/                  ← .atosw Reader & Symbolication Service (whatap)
├── whatap-stack-repository/       ← Stack Trace 디코딩 서비스 (whatap)
│
├── # ── Testing & QA ───────────────────────────────
├── whatap-ios-qa-guide/           ← iOS QA 가이드 문서 (devload)
├── ios-sample-apps/               ← iOS 샘플 앱 모음 (devload)
├── webview-sample-ios-whatap/     ← WebView 모니터링 샘플 앱 (devload)
├── ios-simulator-tools/           ← iOS 시뮬레이터 제어 도구 (devload)
├── ios-device-list/               ← Apple 디바이스 목록 (devload)
│
├── # ── Tools ──────────────────────────────────────
├── demo-generator/                ← Mock 모니터링 데이터 생성 (whatap)
├── whatap-mobile-proxy-server/    ← 모바일 SDK 프록시 서버 (whatap)
│
├── # ── Workspace ──────────────────────────────────
├── docs/                          ← 통합 문서 (로컬)
├── scripts/                       ← 유틸리티 스크립트
└── .claude/commands/              ← Claude Code slash commands
```

## 카테고리별 서비스

### iOS Agent SDK

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **iosAgent** | iOS Agent SDK 소스 | Objective-C/Swift, Makefile | whatap |
| **WhatapIOSAgent-Release** | iOS Agent 릴리즈 바이너리 (XCFramework) | Swift | whatap |

### Mobile Spec & Protocol

| 서비스 | 역할 | 소유 |
|--------|------|------|
| **whatap-mobile-agent-spec** | 모바일 Agent 데이터 전송 프로토콜 스펙 | whatap |

### Crash Symbolication (atosw)

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **atosw** | iOS Crash Symbolication Hub | - | whatap |
| **atosw-rust** | dSYM → .atosw 변환기 (Phase 1) | Rust | whatap |
| **atosw-kotlin** | .atosw Reader & Symbolication Service (Phase 2) | Kotlin | whatap |
| **whatap-stack-repository** | Stack Trace 디코딩 서비스 (SourceMap/Proguard/dSYM) | Kotlin | whatap |

### Testing & QA

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **whatap-ios-qa-guide** | iOS QA 가이드 문서 | Markdown | devload |
| **ios-sample-apps** | iOS 샘플 앱 모음 (다양한 비즈니스 도메인) | Objective-C/Swift | devload |
| **webview-sample-ios-whatap** | WebView 모니터링 샘플 앱 | Swift | devload |
| **ios-simulator-tools** | iOS 시뮬레이터 제어 슬래시 명령어 모음 | Shell | devload |
| **ios-device-list** | Apple 디바이스 목록 (검색 가능) | HTML | devload |

### Tools

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **demo-generator** | Mock 모니터링 데이터 생성 | TypeScript | whatap |
| **whatap-mobile-proxy-server** | 모바일 SDK 데이터 전송 프록시 서버 | JavaScript | whatap |

## 개발 환경

### 빌드 환경 요구사항

| 도구 | 버전 | 용도 |
|------|------|------|
| Xcode | 15+ | iOS Agent 빌드, 샘플 앱 |
| Swift | 5.9+ | iOS Agent SDK |
| CocoaPods | latest | 의존성 관리 |
| Rust | latest | atosw-rust 빌드 |
| Node.js | 18+ | demo-generator, proxy-server |
| Java | 17 | atosw-kotlin, whatap-stack-repository |

### iOS Agent 빌드 플로우

```
iosAgent/ (소스)
│
├── WhatapAgent.xcodeproj       ← Xcode 프로젝트
├── Sources/                     ← Agent 소스 코드
└── Makefile                     ← 빌드 자동화

→ 빌드 산출물: WhatapIOSAgent-Release/ (XCFramework)
```

### dSYM Symbolication 플로우

```
1. dSYM 파일 수집 (Xcode Archive → dSYM)
2. atosw-rust: dSYM → .atosw (경량 바이너리) 변환
3. atosw-kotlin: .atosw 읽기 & 주소 → 심볼 변환 서비스
4. whatap-stack-repository: API 서빙 & 통합 디코딩
```

## 주의사항

- whatap org 레포는 push 시 조직 권한 필요
- devload 레포는 개인 소유 — 자유롭게 push 가능
- `docs/`는 submodule이 아닌 일반 디렉토리
- 새 프로젝트 추가: `git submodule add https://github.com/{org}/{repo}.git {name}`

## Claude Code Skills

| 명령어 | 설명 |
|--------|------|
| `/build-agent` | iOS Agent 빌드 |
| `/sim-run` | 시뮬레이터에서 샘플 앱 실행 |
| `/sim-logs` | 시뮬레이터/디바이스 WhatAp 로그 확인 |
| `/dsym-convert` | dSYM → .atosw 변환 |
| `/worktree-status` | Git worktree 상태 확인 |
| `/proxy-server` | 모바일 프록시 서버 시작/중지 |
