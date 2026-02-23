# WhaTap iOS Workspace

WhaTap iOS 모니터링 관련 프로젝트 통합 개발 환경. 14개 서비스를 git submodule로 관리합니다.
iOS Agent SDK, Crash Symbolication (atosw), QA/테스트, 도구 프로젝트 포함.

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
| **iosAgent** | iOS Agent SDK 소스 | Objective-C/Swift, Xcode | whatap |
| **WhatapIOSAgent-Release** | iOS Agent 릴리즈 바이너리 (XCFramework) | Swift, SPM/CocoaPods | whatap |

### Mobile Spec & Protocol

| 서비스 | 역할 | 소유 |
|--------|------|------|
| **whatap-mobile-agent-spec** | 모바일 Agent 데이터 전송 프로토콜 스펙 | whatap |

### Crash Symbolication (atosw)

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **atosw** | iOS Crash Symbolication Hub (문서) | - | whatap |
| **atosw-rust** | dSYM → .atosw 변환기 (Phase 1) | Rust | whatap |
| **atosw-kotlin** | .atosw Reader & Symbolication Service (Phase 2) | Kotlin | whatap |
| **whatap-stack-repository** | Stack Trace 디코딩 서비스 (SourceMap/Proguard/dSYM) | Kotlin, Spring Boot | whatap |

### Testing & QA

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **whatap-ios-qa-guide** | iOS QA 가이드 문서 | Markdown | devload |
| **ios-sample-apps** | iOS 샘플 앱 모음 (8개: Swift 2 + ObjC 6) | Objective-C/Swift | devload |
| **webview-sample-ios-whatap** | WebView 모니터링 샘플 앱 | Swift | devload |
| **ios-simulator-tools** | iOS 시뮬레이터 제어 슬래시 명령어 모음 | Shell | devload |
| **ios-device-list** | Apple 디바이스 목록 (검색 가능) | HTML | devload |

### Tools

| 서비스 | 역할 | 기술 스택 | 소유 |
|--------|------|-----------|------|
| **demo-generator** | Mock 모니터링 데이터 생성 | TypeScript | whatap |
| **whatap-mobile-proxy-server** | 모바일 SDK 데이터 전송 프록시 서버 | Node.js | whatap |

## 서비스 실행 가이드

### Prerequisites

| 도구 | 용도 | 설치 |
|------|------|------|
| Xcode 15+ | iOS Agent 빌드, 샘플 앱 | App Store |
| Swift 5.9+ | iOS Agent SDK | Xcode 포함 |
| CocoaPods | 의존성 관리 | `brew install cocoapods` |
| Rust/Cargo | atosw-rust | `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \| sh` |
| Node.js 18+ | demo-generator, proxy-server | `brew install node` |
| Java 17 | atosw-kotlin, whatap-stack-repository | `brew install openjdk@17` |
| Maven 3.8+ | whatap-stack-repository | `brew install maven` |

### 포트 맵

| 서비스 | 포트 | 비고 |
|--------|------|------|
| whatap-mobile-proxy-server | 6600 | `npm start` |
| whatap-stack-repository | 8090 | Spring Boot (Maven) |

---

### iOS Agent SDK

#### iosAgent

```
iosAgent/
├── WhatapAgent.xcodeproj    ← Xcode 프로젝트
├── WhatapAgent/              ← Agent 소스 코드
├── WhatapAgentTests/         ← 테스트
├── PLCrashReporter/          ← 크래시 리포터 (통합)
├── TestApps/                 ← 내장 테스트 앱
├── scripts/                  ← 빌드 스크립트
│   ├── build-qa-release.sh
│   ├── build-xcframework-integrated.sh
│   └── build-xcframework-umbrella.sh
└── Package.swift             ← SPM 지원
```

```bash
cd iosAgent

# Xcode 빌드
xcodebuild -project WhatapAgent.xcodeproj -scheme WhatapAgent -configuration Release

# XCFramework 빌드 (QA 릴리즈)
./scripts/build-qa-release.sh

# XCFramework 빌드 (통합 버전)
./scripts/build-xcframework-integrated.sh
```

#### WhatapIOSAgent-Release

```bash
# 릴리즈 바이너리 — 빌드 대상 아님
# SPM으로 사용:
# .package(url: "https://github.com/whatap/WhatapIOSAgent-Release.git", from: "1.0.0")

# CocoaPods으로 사용:
# pod 'WhatapAgent'
```

---

### Crash Symbolication (atosw)

#### atosw (문서)
> 빌드 대상 아님 — atosw-rust, atosw-kotlin의 상위 프로젝트 문서

#### atosw-rust
```bash
cd atosw-rust
cargo build --release
# 바이너리: target/release/atosw

# dSYM → .atosw 변환
./target/release/atosw build --dsym MyApp.dSYM --output MyApp.atosw

# 주소 심볼리케이션
./target/release/atosw lookup -o MyApp.atosw -l 0x100000000 0x100001234

# .atosw 파일 검증
./target/release/atosw validate --path MyApp.atosw
```

#### atosw-kotlin
```bash
cd atosw-kotlin
./gradlew build       # 빌드 + 테스트
./gradlew test        # 테스트만
```
> 라이브러리 — .atosw 파일 읽기 및 심볼리케이션 API 제공

#### whatap-stack-repository
```bash
cd whatap-stack-repository
mvn clean package -DskipTests
java -jar target/whatap.server.stackrepository-0.0.1.jar   # :8090

# 또는
mvn spring-boot:run
```
API:
- `POST /api/sourcemap/decode` — SourceMap 디코딩
- `POST /api/proguard/decode` — ProGuard 디코딩
- `POST /api/dsym/decode` — dSYM 디코딩

---

### Testing & QA

#### ios-sample-apps

```
ios-sample-apps/
├── Complex-Apps/
│   ├── ECommerceApp/      ← Swift 이커머스 앱
│   └── SocialMediaApp/    ← Swift SNS 앱
├── ObjectiveC-Apps/
│   ├── EducationApp/      ← 교육 앱
│   ├── FoodApp/           ← 음식 앱
│   ├── HealthApp/         ← 건강 앱
│   ├── MusicApp/          ← 음악 앱
│   ├── NewsApp/           ← 뉴스 앱
│   └── TravelApp/         ← 여행 앱
└── Tools/                 ← 앱 생성 스크립트
```

```bash
cd ios-sample-apps/Complex-Apps/ECommerceApp

# 시뮬레이터 빌드 & 실행
xcodebuild -project *.xcodeproj -scheme ECommerceApp \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build

# 또는 Xcode에서 열기
open *.xcodeproj
```

#### webview-sample-ios-whatap
```bash
cd webview-sample-ios-whatap
open *.xcodeproj
# Xcode에서 시뮬레이터 선택 후 Run (⌘R)
```

#### ios-simulator-tools
> Claude Code 슬래시 명령어 모음 — 직접 실행 대상 아님

포함된 명령어:
- `sim-app` — 시뮬레이터에 앱 설치
- `sim-boot` — 시뮬레이터 부팅
- `sim-crash` — 크래시 로그 수집
- `sim-install` — SDK 설치
- `sim-logs` — 로그 스트리밍
- `sim-stream` — 화면 스트리밍

#### whatap-ios-qa-guide
> QA 테스트 가이드 문서 — 빌드 대상 아님

---

### Tools

#### demo-generator
```bash
cd demo-generator
npm install
npm run build     # TypeScript 빌드
npm start         # Mock 데이터 전송 시작
npm run dev       # 개발 모드 (ts-node)
```

#### whatap-mobile-proxy-server
```bash
cd whatap-mobile-proxy-server
npm install
npm start         # :6600

# 개발 모드 (nodemon)
npm run dev
```
> iOS Agent의 서버 주소를 `http://localhost:6600`으로 변경하여 데이터 캡처 확인 가능

---

## 핵심 개발 워크플로우

```
1. Agent 소스 수정 (iosAgent/)
   ↓
2. XCFramework 빌드 (./scripts/build-xcframework-integrated.sh)
   ↓
3. 샘플 앱에 적용 (ios-sample-apps/ 또는 webview-sample-ios-whatap/)
   ↓
4. 시뮬레이터에서 테스트 (/sim-run)
   ↓
5. WhatAp 로그 확인 (/sim-logs)
   ↓
6. WhatAp 대시보드에서 데이터 확인
```

### dSYM Symbolication 플로우

```
1. Xcode Archive → dSYM 파일 추출
   ↓
2. atosw-rust: dSYM → .atosw 변환 (경량화)
   $ cd atosw-rust && cargo run -- build --dsym MyApp.dSYM --output MyApp.atosw
   ↓
3. atosw-kotlin: .atosw 파일 기반 주소 → 심볼 변환
   ↓
4. whatap-stack-repository: REST API로 디코딩 서비스 제공 (:8090)
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

## Submodule 관리

```bash
# 전체 서브모듈 최신으로
git submodule update --remote --merge

# 특정 서브모듈만
cd iosAgent && git pull origin main && cd ..

# 서브모듈 상태 확인
git submodule status

# 새 서브모듈 추가
git submodule add https://github.com/whatap/NEW_REPO.git NEW_REPO
```

## 주의사항

- whatap org 레포는 push 시 조직 권한 필요
- devload 레포는 개인 소유 — 자유롭게 push 가능
- `docs/`는 submodule이 아닌 일반 디렉토리
- 새 프로젝트 추가: `git submodule add https://github.com/{org}/{repo}.git {name}`
