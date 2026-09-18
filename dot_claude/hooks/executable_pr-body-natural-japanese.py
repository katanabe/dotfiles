#!/usr/bin/env python3
"""PR 本文を投稿する前に natural-japanese の lint を通す PreToolUse フック。

`gh pr create` / `gh pr edit` が `--body-file` で本文を渡すときだけ働く。
lint が何か見つけたら permissionDecision=ask で止め、見つからなければ黙って通す
(毎回確認を挟むと、指摘が無い回まで手が止まるため)。

lint が拾えるのは表層 (禁止語・翻訳調・リズム) だけで、構造レビューは拾えない。
そこは reason に書いて Claude 側に回す。
"""

import json
import re
import shlex
import subprocess
import sys
from pathlib import Path

SKILL = Path.home() / ".claude/skills/natural-japanese"
LINT = SKILL / "scripts/lint.py"
TARGET = re.compile(r"\bgh\s+pr\s+(create|edit)\b")


def allow() -> None:
    """判断を足さずに通常フローへ返す。"""
    sys.exit(0)


def body_file_of(command: str) -> str | None:
    try:
        argv = shlex.split(command)
    except ValueError:
        return None
    for i, arg in enumerate(argv):
        if arg == "--body-file" and i + 1 < len(argv):
            return argv[i + 1]
        if arg.startswith("--body-file="):
            return arg.split("=", 1)[1]
    return None


def lint(path: str) -> str | None:
    """findings があれば本文を返す。無ければ None。"""
    try:
        proc = subprocess.run(
            ["uv", "run", "--with", "sudachipy", "--with", "sudachidict_core",
             "python", str(LINT), "--genre", "tech", path],
            capture_output=True, text=True, timeout=180, cwd=SKILL,
        )
    except (OSError, subprocess.TimeoutExpired):
        return None
    out = proc.stdout
    return None if "検出なし" in out else out


def main() -> None:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        allow()

    command = (payload.get("tool_input") or {}).get("command", "")
    if not TARGET.search(command):
        allow()

    path = body_file_of(command)
    if not path or not Path(path).exists():
        allow()

    findings = lint(path)
    if findings is None:
        allow()

    reason = (
        "natural-japanese の lint が PR 本文に指摘を出しました。"
        "投稿前に見直してください。\n\n"
        f"{findings}\n"
        "lint は表層 (禁止語・翻訳調・リズム) しか見ません。"
        "スケルトン通読 (outline.py) による構造レビューは別途行ってください。"
    )
    print(json.dumps({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "ask",
            "permissionDecisionReason": reason,
        }
    }, ensure_ascii=False))


if __name__ == "__main__":
    main()
