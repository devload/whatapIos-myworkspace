# Simulator Run

iOS 시뮬레이터에서 샘플 앱을 빌드하고 실행합니다.

## Arguments

- `$ARGUMENTS` — 샘플 앱 이름 또는 경로. 없으면 ios-sample-apps/ 목록 표시.

## Instructions

1. 인자가 없으면 `ios-sample-apps/` 내 프로젝트 목록 출력
2. 인자가 있으면 해당 앱 디렉토리로 이동
3. 사용 가능한 시뮬레이터 확인: `xcrun simctl list devices available | grep iPhone`
4. 최신 iPhone 시뮬레이터 선택
5. 시뮬레이터 부팅: `xcrun simctl boot <device-id>` (이미 부팅된 경우 스킵)
6. `xcodebuild` 또는 `xcodebuild -workspace`로 빌드:
   ```
   xcodebuild -project *.xcodeproj -scheme <scheme> \
     -destination 'platform=iOS Simulator,name=<simulator>' \
     build
   ```
7. 빌드 성공 시 앱 설치 & 실행
8. Simulator.app 열기: `open -a Simulator`

## Output

- 사용한 시뮬레이터 이름
- 빌드 결과 (성공/실패)
- 앱 실행 상태
