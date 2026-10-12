#!/usr/bin/env bash
# Claude Code가 MCP로 REA를 불러서 분석 → 복원 → 테스트까지 하게 한다.
# 설정 파일을 바꾸지 않도록 이번 실행에만 --mcp-config 로 REA를 붙인다.
set -euo pipefail
cd "$(dirname "$0")"
[ -f env.sh ] && source env.sh
WORK="$PWD/work/agent-run"
rm -rf "$WORK" && mkdir -p "$WORK"
clang -O1 -o "$WORK/pan" native/pan.c          # 에이전트에게는 바이너리만 준다
sed "s#__GHIDRA__#${GHIDRA_INSTALL_DIR:-}#; s#__JAVA__#${JAVA_HOME:-}#" agent/rea-mcp.template.json > "$WORK/rea-mcp.json"
cd "$WORK"
claude --model "${MODEL:-sonnet}" --setting-sources project --mcp-config rea-mcp.json --strict-mcp-config \
  --allowedTools "mcp__rea__*" "Write" "Read" "Edit" "Bash(clang:*)" "Bash(cc:*)" "Bash(./pan:*)" "Bash(./recon:*)" "Bash(bash:*)" "Bash(sh:*)" "Bash(zsh:*)" "Bash(chmod:*)" "Bash(seq:*)" "Bash(for:*)" "Bash(diff:*)" "Bash(cat:*)" "Bash(ls:*)" \
  -- "$(cat "$OLDPWD/agent/prompt.txt")"
