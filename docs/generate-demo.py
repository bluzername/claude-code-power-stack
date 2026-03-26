#!/usr/bin/env python3
"""Generate a terminal demo SVG for the README using rich."""

from rich.console import Console
from rich.text import Text
from rich.panel import Panel
from rich.table import Table
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
OUTPUT = SCRIPT_DIR.parent / "assets" / "demo.svg"
OUTPUT.parent.mkdir(exist_ok=True)

console = Console(record=True, width=72, force_terminal=True)

# Simulate a ccs session
console.print()
console.print("[dim]$[/dim] [bold]ccs \"auth middleware\"[/bold]")
console.print()

# Search results
console.print("[bold yellow][1][/bold yellow] 2025-03-25 14:00  [cyan]~/projects/api[/cyan]  (198 msgs)")
console.print("    [dim]Add JWT authentication middleware to Express routes...[/dim]")
console.print()
console.print("[bold yellow][2][/bold yellow] 2025-03-23 10:30  [cyan]~/projects/api[/cyan]  (45 msgs)")
console.print("    [dim]Research JWT library options for the API...[/dim]")
console.print()
console.print("[green]2 sessions found.[/green] Resume with: [bold]ccs go 1[/bold]")
console.print()

# Resume
console.print("[dim]$[/dim] [bold]ccs go 1[/bold]")
console.print("[dim]Resuming result #1: ~/projects/api[/dim]")
console.print("[dim]Claude picks up at Phase 3 - Ghost loads decisions, planning files show progress.[/dim]")
console.print()

# Divider
console.rule("[bold]Team Mode[/bold]", style="blue")
console.print()

# Team log
console.print("[dim]$[/dim] [bold]ccs team log d \"Using RS256 for JWT tokens\"[/bold]")
console.print("[green]Logged[/green] [decision] Using RS256 for JWT tokens")
console.print("[yellow]Tip:[/yellow] run [bold]ccs team sync[/bold] to share with your team")
console.print()

# Team standup
console.print("[dim]$[/dim] [bold]ccs team standup[/bold]")
console.print()
console.print("  [bold]Team Standup - 2025-03-26[/bold]")
console.print("  ========================================")
console.print()
console.print("  [bold cyan]Team (last 48h)[/bold cyan]")
console.print("    [bold]@alice[/bold] (you) [cyan][decision][/cyan] Using RS256 for JWT tokens")
console.print("    [bold]@bob[/bold] [green][done][/green] Phase 2 complete - token generation")
console.print("    [bold]@bob[/bold] [red][blocker][/red] CI fails on ARM builds")
console.print()
console.print("  [bold red]Blockers[/bold red]")
console.print("    @bob CI fails on ARM builds")
console.print()

svg = console.export_svg(title="ccs - Claude Code Search", theme=None)
OUTPUT.write_text(svg)
print(f"Generated: {OUTPUT}")
