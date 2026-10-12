#!/usr/bin/env bash
# REA가 이 컴퓨터에서 쓸 준비가 됐는지 확인한다. Ghidra 경로는 env.sh에 적어 둔다.
set -euo pipefail
cd "$(dirname "$0")"
[ -f env.sh ] && source env.sh
npx -y rea-agents@latest doctor --provider ghidra --format json 2>/dev/null | python3 lib/doctor_summary.py
