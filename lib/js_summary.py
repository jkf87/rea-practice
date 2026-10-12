#!/usr/bin/env python3
"""rea analyze-javascript-application --format json 결과에서 Electron 연결 구조만 짧게 뽑는다."""
import json, sys

d = json.load(sys.stdin)
n = d["normalized_result"]
s = n["summary"]
nodes = n["graph"]["nodes"]

def props(node):
    return node["observations"][0]["properties"]

print(f"창 {s['browser_windows']}개 · preload {s['preload_entrypoints']}개 · IPC 채널 {s['ipc']['literal_channels']}개")
for node in nodes:
    if node["kind"] == "context-bridge-api":
        p = props(node)
        print(f"preload가 공개한 API  window.{p['api_key']} → {', '.join(p['members'])}")
pairs = {}
for node in nodes:
    if node["kind"] in ("ipc-channel", "ipc-handler"):
        p = props(node)
        pairs.setdefault(p["channel"], {})[p["side"]] = p
for ch, sides in sorted(pairs.items()):
    h = sides.get("main", {})
    loc = h.get("handler_location", {}).get("start", {})
    where = f"main.js {loc.get('line')}번째 줄" if loc else "위치 모름"
    print(f"IPC  {ch:<14} 렌더러 invoke → 메인 handle ({where})")
print(f"발신자 검증 코드 {s['sender_validation_observations']}건")
