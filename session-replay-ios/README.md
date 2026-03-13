# iOS Session Replay

iOS 앱 화면을 캡처하여 웹 플레이어에서 재생하는 세션 리플레이 라이브러리입니다.

## 구조

```
session-replay-ios/
├── Package.swift                    # SPM 메인 패키지
├── WhatapSessionSnapshot/           # View 캡처 라이브러리
│   ├── Package.swift
│   └── Sources/
│       ├── ViewData.swift          # 데이터 모델
│       ├── ViewCapture.swift       # UIView hierarchy 캡처
│       └── Extensions.swift        # UIColor/UIFont 확장
├── WhatapSessionRecorder/          # 녹화 관리 라이브러리
│   ├── Package.swift
│   └── Sources/
│       ├── SessionRecorder.swift   # 녹화 컨트롤러
│       ├── EventQueue.swift        # 이벤트 큐
│       ├── NetworkClient.swift     # 서버 전송
│       └── Models.swift            # 이벤트 모델
├── SampleApp/                      # 샘플 앱
│   └── SessionReplaySample/
└── server/                         # Node.js 서버 + 웹 플레이어
    ├── server.js
    └── player/
```

## 빠른 시작

### 1. 서버 실행

```bash
cd server
npm install
npm start
# Server running at http://localhost:3000
```

### 2. Xcode 프로젝트 생성

```bash
# Xcode에서 새 프로젝트 생성
# File > New > Project > iOS > App
# Product Name: SessionReplaySample
# Interface: Storyboard (또는 SwiftUI)
# Language: Swift

# 생성된 프로젝트의 파일을 SampleApp/SessionReplaySample/의 파일로 교체
```

### 3. 패키지 추가

Xcode에서:
1. File > Add Packages...
2. Add Local... 선택
3. `session-replay-ios` 폴더 선택
4. WhatapSessionSnapshot, WhatapSessionRecorder 추가

### 4. 코드에서 사용

```swift
import UIKit
import WhatapSessionRecorder

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        // ... rootViewController 설정

        // 세션 리플레이 시작
        SessionRecorder.shared.startRecording(in: window!)
    }
}
```

## API

### SessionRecorder

```swift
// 녹화 시작
SessionRecorder.shared.startRecording(in: window)

// 녹화 중지
SessionRecorder.shared.stopRecording()

// 일시 정지/재개
SessionRecorder.shared.pauseRecording()
SessionRecorder.shared.resumeRecording()

// 즉시 전송
SessionRecorder.shared.flush()
```

### ViewCapture

```swift
// 단일 뷰 캡처
let viewData = ViewCapture.shared.captureView(view)

// 윈도우 전체 캡처
let snapshot = ViewCapture.shared.captureWindow(window)
```

## 데이터 포맷

### View 트리

```json
{
  "id": 12345,
  "type": "UILabel",
  "bounds": { "left": 0, "top": 44, "right": 375, "bottom": 88 },
  "backgroundColor": "#FFFFFFFF",
  "alpha": 1.0,
  "visibility": "visible",
  "text": "Hello World",
  "textSize": 16,
  "textColor": "#FF000000",
  "fontWeight": 400,
  "children": [...]
}
```

### 전체 스냅샷

```json
{
  "timestamp": 1234567890123,
  "screenWidth": 375,
  "screenHeight": 812,
  "scale": 3,
  "root": { ... }
}
```

### 이벤트 전송

```json
POST /api/events
{
  "sessionId": "uuid-string",
  "events": [
    {
      "type": "full_snapshot",
      "timestamp": 1234567890123,
      "data": { ... }
    }
  ]
}
```

## 서버 API

| Method | Endpoint | 설명 |
|--------|----------|------|
| POST | /api/events | 이벤트 수신 |
| GET | /api/sessions | 세션 목록 |
| GET | /api/sessions/:id | 세션 상세 |
| GET | /api/sessions/:id/replay | 재생용 스냅샷 |
| DELETE | /api/sessions/:id | 세션 삭제 |

## 웹 플레이어

http://localhost:3000/player/ 에서 세션을 재생할 수 있습니다.
- 세션 선택
- Play/Pause
- Prev/Next 스냅샷
- Debug Mode (뷰 경계 표시)
