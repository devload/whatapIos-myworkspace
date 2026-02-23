# Worktree Status

주요 프로젝트의 git worktree 상태를 확인합니다.

## Instructions

1. `iosAgent/` 디렉토리에서 `git worktree list` 실행
2. `WhatapIOSAgent-Release/` 디렉토리에서 `git worktree list` 실행
3. `atosw-rust/` 디렉토리에서 `git worktree list` 실행
4. `atosw-kotlin/` 디렉토리에서 `git worktree list` 실행
5. 각 worktree의 브랜치, 커밋 해시, 경로를 정리하여 출력
6. 각 worktree에서 `git status --short` 실행하여 변경사항 유무 확인

## Output

테이블 형식으로 출력:

| 프로젝트 | 경로 | 브랜치 | 변경사항 |
|----------|------|--------|----------|
| iosAgent | /path | main | clean |
| WhatapIOSAgent-Release | /path | main | 1 modified |
| atosw-rust | /path | main | clean |
| atosw-kotlin | /path | main | clean |
