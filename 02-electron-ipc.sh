#!/usr/bin/env bash
# 직접 만든 샘플 메모 앱(sample-notes-app)을 실행하지 않고 정적으로 분석한다.
set -euo pipefail
cd "$(dirname "$0")"
npx -y rea-agents@latest analyze-javascript-application "$PWD/sample-notes-app" --format json 2>/dev/null \
  | python3 lib/js_summary.py
