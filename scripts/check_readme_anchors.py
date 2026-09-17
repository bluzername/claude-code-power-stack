#!/usr/bin/env python3
"""Fail if README.md contains a (#anchor) link with no matching heading.

Slugs follow GitHub's rules: lowercase, punctuation stripped, spaces to hyphens,
duplicates suffixed with -1, -2, ...
"""

import re
import sys
from pathlib import Path

README = Path(__file__).resolve().parent.parent / "README.md"
HEADING = re.compile(r"^#{1,6}\s+(.*?)\s*#*\s*$")
ANCHOR = re.compile(r"\]\(#([^)]+)\)")
STRIP = re.compile(r"[^\w\- ]", re.UNICODE)


def slugify(text: str) -> str:
    text = re.sub(r"`([^`]*)`", r"\1", text)
    text = re.sub(r"\[([^\]]*)\]\([^)]*\)", r"\1", text)
    text = STRIP.sub("", text.strip().lower())
    return text.replace(" ", "-")


def heading_slugs(lines: list[str]) -> set[str]:
    seen: dict[str, int] = {}
    slugs: set[str] = set()
    in_code = False
    for line in lines:
        if line.startswith("```"):
            in_code = not in_code
            continue
        if in_code:
            continue
        match = HEADING.match(line)
        if not match:
            continue
        base = slugify(match.group(1))
        count = seen.get(base, 0)
        seen[base] = count + 1
        slugs.add(base if count == 0 else f"{base}-{count}")
    return slugs


def main() -> int:
    text = README.read_text(encoding="utf-8")
    slugs = heading_slugs(text.splitlines())
    missing = sorted({a for a in ANCHOR.findall(text) if a not in slugs})
    for anchor in missing:
        print(f"FAIL: no heading for #{anchor}")
    if missing:
        return 1
    print(f"OK: all {len(set(ANCHOR.findall(text)))} README anchors resolve")
    return 0


if __name__ == "__main__":
    sys.exit(main())
