# Simulator/Device Logs

시뮬레이터 또는 디바이스에서 WhatAp 관련 로그를 확인합니다.

## Arguments

- `$ARGUMENTS` — 옵션: `live` (실시간 스트리밍, 기본 30초), `dump` (현재 버퍼 덤프), `clear` (로그 클리어 후 수집), 숫자 (수집 시간 초)

## Instructions

1. 시뮬레이터 실행 여부 확인: `xcrun simctl list devices | grep Booted`
2. 실제 디바이스 연결 확인: `xcrun xctrace list devices`
3. 인자에 따라 동작:
   - `dump` 또는 인자 없음:
     ```
     xcrun simctl spawn booted log show --predicate 'subsystem CONTAINS "whatap" OR eventMessage CONTAINS "whatap" OR eventMessage CONTAINS "WhatAp"' --last 5m --style compact | tail -50
     ```
   - `live` 또는 숫자:
     ```
     timeout <초> xcrun simctl spawn booted log stream --predicate 'subsystem CONTAINS "whatap" OR eventMessage CONTAINS "whatap" OR eventMessage CONTAINS "WhatAp"' --level debug
     ```
   - `clear`: 시뮬레이터 재시작 후 새 로그 수집
4. 로그에서 에러/경고 패턴 하이라이트
5. Agent 초기화, 네트워크 전송, 크래시 등 주요 이벤트 요약

## Output

- WhatAp 관련 로그 (최근 50줄 또는 실시간)
- 에러/경고 요약 (있는 경우)
