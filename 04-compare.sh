#!/usr/bin/env bash
# 복원한 코드가 원본과 똑같이 동작하는지 x=-50~700 전 구간을 비교한다.
set -euo pipefail
cd "$(dirname "$0")"
clang -O1 -o native/pan native/pan.c
clang -O1 -o recon/pan_recon recon/pan_recon.c
same=0; diff=0
for x in $(seq -50 700); do
  if [ "$(native/pan "$x")" = "$(recon/pan_recon "$x")" ]; then same=$((same+1)); else diff=$((diff+1)); echo "다름: x=$x"; fi
done
echo "비교 $((same+diff))건 · 일치 $same · 불일치 $diff"
