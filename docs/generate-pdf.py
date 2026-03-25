#!/usr/bin/env python3
"""
Generate a printable PDF cheat sheet from cheatsheet.md.

Dependencies: pip install markdown weasyprint
Usage: python3 generate-pdf.py
Output: cheatsheet.pdf
"""

import sys
from pathlib import Path

try:
    import markdown
    from weasyprint import HTML
except ImportError:
    print("Missing dependencies. Install them:")
    print("  pip install markdown weasyprint")
    print("")
    print("On macOS you may also need:")
    print("  brew install pango")
    sys.exit(1)

SCRIPT_DIR = Path(__file__).parent
CHEATSHEET_MD = SCRIPT_DIR / "cheatsheet.md"
OUTPUT_PDF = SCRIPT_DIR / "cheatsheet.pdf"

CSS = """
@page {
    size: A4;
    margin: 1.5cm;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
    font-size: 10pt;
    line-height: 1.4;
    color: #1a1a1a;
    max-width: 100%;
}

h1 {
    font-size: 18pt;
    border-bottom: 2px solid #6366f1;
    padding-bottom: 6px;
    margin-bottom: 12px;
    color: #1e1b4b;
}

h2 {
    font-size: 12pt;
    color: #3730a3;
    margin-top: 14px;
    margin-bottom: 6px;
    border-bottom: 1px solid #e0e7ff;
    padding-bottom: 3px;
}

h3 {
    font-size: 10pt;
    color: #4338ca;
    margin-top: 10px;
    margin-bottom: 4px;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 6px 0;
    font-size: 9pt;
}

th {
    background: #eef2ff;
    color: #3730a3;
    text-align: left;
    padding: 4px 8px;
    border: 1px solid #c7d2fe;
    font-weight: 600;
}

td {
    padding: 3px 8px;
    border: 1px solid #e0e7ff;
}

tr:nth-child(even) td {
    background: #f8faff;
}

code {
    background: #f1f5f9;
    padding: 1px 4px;
    border-radius: 3px;
    font-family: "SF Mono", "Fira Code", Menlo, monospace;
    font-size: 8.5pt;
    color: #1e293b;
}

pre {
    background: #1e293b;
    color: #e2e8f0;
    padding: 8px 12px;
    border-radius: 6px;
    font-size: 8.5pt;
    line-height: 1.3;
    overflow-wrap: break-word;
    white-space: pre-wrap;
}

pre code {
    background: none;
    color: inherit;
    padding: 0;
}

strong {
    color: #1e1b4b;
}

hr {
    border: none;
    border-top: 1px solid #c7d2fe;
    margin: 10px 0;
}

p {
    margin: 4px 0;
}

ul, ol {
    margin: 4px 0;
    padding-left: 20px;
}

li {
    margin: 2px 0;
}
"""


def main():
    if not CHEATSHEET_MD.exists():
        print(f"Error: {CHEATSHEET_MD} not found")
        sys.exit(1)

    md_content = CHEATSHEET_MD.read_text()

    html_body = markdown.markdown(
        md_content,
        extensions=["tables", "fenced_code"],
    )

    full_html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>{CSS}</style>
</head>
<body>
{html_body}
</body>
</html>"""

    HTML(string=full_html).write_pdf(str(OUTPUT_PDF))
    print(f"Generated: {OUTPUT_PDF}")


if __name__ == "__main__":
    main()
