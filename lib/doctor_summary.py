#!/usr/bin/env python3
"""rea doctor --format json 결과에서 실습에 필요한 항목만 한 줄씩 보여준다."""
import json, sys, unicodedata


def pad(text, width):
    w = sum(2 if unicodedata.east_asian_width(c) in "WF" else 1 for c in text)
    return text + " " * max(0, width - w)

d = json.load(sys.stdin)
checks = {c["name"]: c for c in d.get("scope_checks", []) + d.get("informational_checks", [])}
rows = [("node", "Node.js"), ("ghidra-version", "Ghidra"), ("ghidra-java", "JDK"),
        ("ghidra-native_decompiler", "디컴파일러"), ("hopper", "Hopper(선택)")]
for key, label in rows:
    c = checks.get(key)
    if not c:
        continue
    mark = "✓" if c["ok"] else "✗"
    detail = (c.get("detail") or c.get("classification") or "").split(";")[0]
    if key == "ghidra-native_decompiler":
        detail = "arm64 일치" if c["ok"] else detail
    print(f"{mark} {pad(label, 13)} {detail[:60]}")
print("REA 준비:", "완료" if d.get("healthy") else "부족")
