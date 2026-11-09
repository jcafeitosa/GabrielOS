#!/usr/bin/env python3
"""Check local targets in Markdown links for tracked repository documents."""

from pathlib import Path
import re
import subprocess
from urllib.parse import unquote, urlsplit


files = subprocess.run(
    ["git", "ls-files", "--cached", "--", "*.md"],
    check=True,
    capture_output=True,
    text=True,
).stdout.splitlines()
link_pattern = re.compile(r"!?\[[^\]]*\]\(([^)]+)\)")
failures: list[str] = []

for name in files:
    source = Path(name)
    content = source.read_text(encoding="utf-8")
    for raw_target in link_pattern.findall(content):
        target = raw_target.strip().split(maxsplit=1)[0].strip("<>")
        parsed = urlsplit(target)
        if parsed.scheme or target.startswith("#"):
            continue

        local_target = unquote(parsed.path)
        if not local_target:
            candidate = source
        else:
            candidate = (source.parent / local_target).resolve()

        if not candidate.exists():
            failures.append(f"{source}: missing link target {local_target}")

if failures:
    print("\n".join(failures))
    raise SystemExit(1)

print(f"Checked local Markdown links in {len(files)} files.")
