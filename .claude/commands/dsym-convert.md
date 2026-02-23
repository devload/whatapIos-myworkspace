# dSYM Convert

dSYM 파일을 .atosw 형식으로 변환합니다.

## Arguments

- `$ARGUMENTS` — dSYM 파일 경로. 없으면 최근 Xcode 아카이브에서 탐색.

## Instructions

1. atosw-rust 빌드 확인:
   - `atosw-rust/target/release/atosw` 존재 여부 확인
   - 없으면: `cd atosw-rust && cargo build --release`
2. dSYM 경로 결정:
   - 인자가 있으면 해당 경로 사용
   - 없으면 `~/Library/Developer/Xcode/Archives/` 에서 최근 아카이브 탐색
3. dSYM → .atosw 변환:
   ```
   atosw-rust/target/release/atosw convert /path/to/app.dSYM -o /tmp/output.atosw
   ```
4. 변환 결과 출력: 원본 크기, 변환 후 크기, 압축률

## Output

- 입력: dSYM 경로, 크기
- 출력: .atosw 경로, 크기
- 압축률
