#!/usr/bin/env bash
# 직접 만든 네이티브 프로그램을 빌드한 뒤, 소스를 안 보고 함수 하나를 의사코드로 되살린다.
set -euo pipefail
cd "$(dirname "$0")"
[ -f env.sh ] && source env.sh
clang -O1 -o native/pan native/pan.c
npx -y rea-agents@latest decompile "$PWD/native/pan" _position_to_pan --provider ghidra --format json 2>/dev/null \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["normalized_result"].strip())'
