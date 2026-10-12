#!/usr/bin/env bash
# Apple Silicon 맥에 JDK 21 + Ghidra 12.1.4를 ~/rea-tools 에 받고 arm64 디컴파일러를 빌드한다.
# sudo·brew 없이 사용자 폴더에만 설치한다. 지우려면 ~/rea-tools 폴더를 지우면 된다.
# 필요: Xcode Command Line Tools(clang, make, bison)
set -euo pipefail
DEST="${REA_TOOLS:-$HOME/rea-tools}"
JDK_URL="https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.12.1%2B1/OpenJDK21U-jdk_aarch64_mac_hotspot_21.0.12.1_1.tar.gz"
GHIDRA_URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_12.1.4_build/ghidra_12.1.4_PUBLIC_20260921.zip"
mkdir -p "$DEST/dl" && cd "$DEST"
[ -d jdk-21.0.12.1+1 ] || { curl -fSL -o dl/jdk.tar.gz "$JDK_URL"; tar xzf dl/jdk.tar.gz; }
[ -d ghidra_12.1.4_PUBLIC ] || { curl -fSL -o dl/ghidra.zip "$GHIDRA_URL"; unzip -q dl/ghidra.zip; }
DEC="$DEST/ghidra_12.1.4_PUBLIC/Ghidra/Features/Decompiler"
if [ ! -x "$DEC/os/mac_arm_64/decompile" ]; then
  # 릴리스에는 macOS arm64용 decompile 실행 파일이 없고 Makefile은 x86_64로 고정돼 있다.
  # 아키텍처를 arm64로 바꾸고, 필요 없는 명령줄 도구(bfd 의존) 의존성 계산은 건너뛴다.
  make -C "$DEC/src/decompile/cpp" -j8 ghidra_opt sleigh_opt \
    ARCH_TYPE="-arch arm64" DEPNAMES="ghi_opt/depend sla_opt/depend"
  mkdir -p "$DEC/os/mac_arm_64"
  install -m 755 "$DEC/src/decompile/cpp/ghidra_opt" "$DEC/os/mac_arm_64/decompile"
  install -m 755 "$DEC/src/decompile/cpp/sleigh_opt" "$DEC/os/mac_arm_64/sleigh"
fi
echo "완료. env.example.sh 를 env.sh 로 복사해 경로를 확인하세요."
