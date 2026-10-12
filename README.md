# REA 실습 — 소스 없이 앱 속을 들여다보기

코난쌤 유튜브 영상 「REA로 앱 역분석하기」에서 보여드린 실습을 직접 따라 할 수 있는 자료예요.
[REA(Reverse Engineer Anything)](https://github.com/morluto/rea)는 에이전트가 MCP로 바이너리·Electron 앱·웹사이트를 분석하게 해 주는 도구예요. 같은 기능을 `rea` 명령으로 터미널에서도 쓸 수 있어요.

> **분석 대상은 이 저장소에서 직접 만든 예제뿐이에요.** 다른 사람의 프로그램을 분석할 때는 라이선스·이용약관·법을 먼저 확인하세요. REA 저장소도 "합법적인 연구·분석·재구성"용이라고 밝히고, 권한 확인 책임은 사용자에게 있다고 적어 두었어요.

## 들어 있는 것

| 경로 | 내용 |
|---|---|
| `sample-notes-app/` | 실습용으로 만든 아주 작은 Electron 메모 앱. 검색·클립보드 복사를 IPC로 처리해요. 실행하지 않고 정적 분석만 해요. |
| `native/pan.c` | 공의 x 위치(0~639)를 스테레오 팬 값(-100~100)으로 바꾸는 C 프로그램. REA 쇼케이스(DX-Ball 사운드 팬)를 흉내 낸 예제예요. |
| `recon/pan_recon.c` | 03의 의사코드만 보고 다시 쓴 복원본 |
| `agent/` | Claude Code에 REA를 이번 실행에만 붙이는 MCP 설정 템플릿과 지시문 |
| `tools/setup-ghidra-macos-arm64.sh` | Apple Silicon 맥에 JDK 21 + Ghidra 12.1.4를 받고 arm64 디컴파일러를 빌드 |

## 준비물

- Node.js 22.19+ / 24.11+ / 26+ 와 npm (REA 요구사항)
- 03~05: 네이티브 분석 엔진. 이 실습은 **Ghidra 12.1.4 + JDK 21**을 써요. Hopper나 IDA도 REA가 지원해요.
- 03~05: `clang` (macOS는 Xcode Command Line Tools)
- 05: [Claude Code](https://code.claude.com/docs) 로그인

### Apple Silicon 맥에서 Ghidra 준비

Ghidra 12.1.4 릴리스에는 macOS arm64용 디컴파일러 실행 파일이 없어요. REA 문서에는 macOS x64 빌드 방법만 있어서, arm64로 빌드하는 스크립트를 넣어 두었어요.

```bash
./tools/setup-ghidra-macos-arm64.sh   # ~/rea-tools 에 설치 (sudo 없음, 약 800MB 내려받기)
cp env.example.sh env.sh               # 경로 확인
```

다른 OS는 [REA 설치 문서](https://github.com/morluto/rea/blob/main/docs/installation.md)를 따라 주세요.

## 순서

```bash
git clone https://github.com/jkf87/rea-practice
cd rea-practice
./01-doctor.sh          # REA 준비 상태 (Node·Ghidra·JDK·디컴파일러)
./02-electron-ipc.sh    # 샘플 앱의 preload API와 IPC 채널을 정적 분석
./03-decompile.sh       # pan 바이너리의 position_to_pan 함수를 의사코드로
./04-compare.sh         # 복원본과 원본을 x=-50~700 전 구간 비교
./05-agent.sh           # Claude Code가 REA로 분석 → 복원 → 테스트
```

### 02 Electron 앱 정적 분석
`rea analyze-javascript-application`이 렌더러 → preload(`window.notes`) → IPC(`notes:search`, `notes:copy`) → 메인 핸들러까지 연결을 찾아요. 결과의 "발신자 검증 코드 0건"은 핸들러가 누가 보낸 요청인지 확인하지 않는다는 뜻이에요. 실제 앱이라면 보안 점검 포인트예요. 다만 REA도 "찾지 못했다는 게 없다는 증거는 아니다"라고 한계를 함께 적어 줘요.

### 03 · 04 함수 되살리기
의사코드의 `0x27f`는 639, `0x668f6d`는 2³²/639에 가까운 값이에요. 컴파일러가 `/ 639` 나눗셈을 곱셈과 시프트로 바꾼 흔적이에요. 이걸 보고 `recon/pan_recon.c`를 썼고, 04에서 751개 입력이 모두 같은 결과인지 확인해요.

### 05 에이전트에게 맡기기
`05-agent.sh`는 임시 폴더에 **바이너리만** 넣고 Claude Code를 띄워요. 개인 설정을 바꾸지 않으려고 `--mcp-config`로 이번 실행에만 REA를 붙였어요.
평소에 계속 쓰려면 REA 공식 방법인 `npx rea-agents setup`으로 에이전트에 등록하세요(설정 백업을 만들고 변경 내용을 보여준 뒤 승인받아요).

## 한계
- 숫자와 결과는 2026-10-12, REA 6.4.0, Ghidra 12.1.4, macOS 26.5(arm64)에서 돌린 값이에요. 버전이 바뀌면 출력 형식이 달라질 수 있어요.
- 예제는 일부러 작게 만들었어요. 실제 앱은 분석 시간이 길고, 의사코드도 훨씬 지저분해요.
- 에이전트 결과는 실행할 때마다 문장이 달라져요.

## 출처
[SOURCES.md](SOURCES.md)

## 라이선스
MIT
