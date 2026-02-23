# Simulator/Device Logs

시뮬레이터 또는 디바이스에서 WhatAp Agent 로그를 확인합니다.

## Arguments

- `$ARGUMENTS` — 옵션: `agent` (Agent stdout 로그, 기본), `system` (시스템 os_log), `live` (실시간 시스템 로그), `dump` (시스템 로그 덤프)

## Important

WhatAp iOS Agent는 `print()` (ConsolePrinter)로 로그를 출력합니다.
- `print()` 출력은 **stdout**으로 전달되며, `os_log` 시스템에 기록되지 않습니다.
- 따라서 `log show` / `log stream`으로는 Agent 로그를 볼 수 없습니다.
- **Agent 로그 캡처는 반드시 `xcrun simctl launch --console`을 사용해야 합니다.**

## Instructions

1. 시뮬레이터 실행 여부 확인: `xcrun simctl list devices | grep Booted`
2. 부팅된 시뮬레이터의 UUID를 확인
3. 인자에 따라 동작:

### `agent` (기본) — WhatAp Agent 로그

앱을 `--console` 모드로 재실행하여 Agent stdout 로그를 캡처합니다.

```bash
# 1. 현재 앱 종료
xcrun simctl terminate booted <BUNDLE_ID>

# 2. --console 모드로 재실행 (stdout 캡처)
xcrun simctl launch --console booted <BUNDLE_ID> 2>&1 | tee /tmp/whatap_agent_log.txt
```

- 기본 Bundle ID: `WhatapLabs.webview-sample` (webview-sample-ios-whatap)
- 캡처되는 로그 예시:
  - Agent 초기화 시퀀스 (Builder, ProjectKey, ServerUrl, PCode)
  - 크래시 리포터 설정
  - OpenTelemetry 초기화
  - 네트워크 요청 인터셉션 (TracingURLProtocol)
  - Span 생성/완료/속성
  - 서버 전송 JSON 페이로드 (Meta, scopeSpans, trace_id, span_id, attributes, metrics)

```bash
# 타임아웃 지정 (30초 후 자동 종료)
timeout 30 xcrun simctl launch --console booted <BUNDLE_ID> 2>&1 | tee /tmp/whatap_agent_log.txt
```

### `system` / `dump` — 시스템 로그 (os_log)

시스템 수준 로그만 캡처합니다. CFNetwork, runningboard 등 OS 레벨 이벤트 확인용.

```bash
xcrun simctl spawn booted log show --predicate 'subsystem CONTAINS "whatap" OR eventMessage CONTAINS "whatap" OR eventMessage CONTAINS "WhatAp"' --last 5m --style compact | tail -50
```

### `live` — 실시간 시스템 로그 스트리밍

```bash
timeout 30 xcrun simctl spawn booted log stream --predicate 'subsystem CONTAINS "whatap" OR eventMessage CONTAINS "whatap" OR eventMessage CONTAINS "WhatAp"' --level debug
```

4. 캡처한 로그에서 분석:
   - `[ERROR]` / `[WARN]` 패턴 하이라이트
   - Agent 초기화 성공 여부 (WhatapConfigBuilder 로그 확인)
   - 네트워크 전송 성공 여부 (HTTP status, response 확인)
   - Span 생성/완료 사이클 정상 여부
   - JSON 페이로드 구조 검증 (Meta, scopeSpans)

## Output

- WhatAp Agent 로그 (stdout 캡처) 또는 시스템 로그
- 에러/경고 요약 (있는 경우)
- Agent 상태 분석 (초기화, 네트워크, Span 처리)
