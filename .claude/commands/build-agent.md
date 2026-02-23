# Build iOS Agent

iOS Agent SDK를 빌드합니다.

## Arguments

- `$ARGUMENTS` — 빌드 타입: `debug` (기본), `release`, `clean`

## Instructions

1. `iosAgent/` 디렉토리로 이동
2. Makefile 존재 여부 확인
3. 인자에 따라 빌드 실행:
   - `debug` 또는 인자 없음: `make build` 또는 `xcodebuild -configuration Debug`
   - `release`: `make release` 또는 `xcodebuild -configuration Release`
   - `clean`: `make clean` 또는 `xcodebuild clean`
4. xcodeproj가 있으면 xcodebuild 사용, 없으면 Makefile 사용
5. 빌드 성공 시 산출물 경로와 크기 출력
6. 빌드 실패 시 에러 메시지 분석 후 해결 방안 제시

## Output

빌드 결과:
- 산출물 경로
- 파일 크기, 빌드 시간 포함
