"""
Runs every query from the queries/ folder against its SQLite database
and prints the results as simple tables.

Usage:
    python run_queries.py                      # all query files
    python run_queries.py university_dining    # only one
"""

import sqlite3
import sys
from pathlib import Path

BASE_DIR = Path(__file__).parent
QUERY_DIR = BASE_DIR / "queries"
DB_DIR = BASE_DIR / "databases"
MAX_ROWS = 15


def split_queries(sql_text):
    """Split a .sql file into (title, query) pairs using the '-- Q' comments."""
    queries = []
    title = None
    lines = []
    for line in sql_text.splitlines():
        if line.startswith("-- Q"):
            title = line[3:].strip()
            lines = []
        elif title is not None and not line.startswith("--"):
            lines.append(line)
            if line.rstrip().endswith(";"):
                queries.append((title, "\n".join(lines)))
                title = None
    return queries


def print_table(headers, rows):
    shown = rows[:MAX_ROWS]
    widths = [max(len(str(v)) for v in [h] + [r[i] for r in shown]) for i, h in enumerate(headers)]
    print("  " + " | ".join(str(h).ljust(w) for h, w in zip(headers, widths)))
    print("  " + "-+-".join("-" * w for w in widths))
    for row in shown:
        print("  " + " | ".join(str(v).ljust(w) for v, w in zip(row, widths)))
    if len(rows) > MAX_ROWS:
        print(f"  ... and {len(rows) - MAX_ROWS} more rows")
    print(f"  ({len(rows)} row{'s' if len(rows) != 1 else ''})")


def run_file(sql_file):
    db_file = DB_DIR / (sql_file.stem + ".sqlite")
    print(f"\n{'=' * 70}\n{sql_file.stem.replace('_', ' ').title()}  ({db_file.name})\n{'=' * 70}")

    with sqlite3.connect(db_file) as conn:
        for title, query in split_queries(sql_file.read_text(encoding="utf-8")):
            print(f"\n{title}")
            cursor = conn.execute(query)
            headers = [col[0] for col in cursor.description]
            print_table(headers, cursor.fetchall())


def main():
    wanted = sys.argv[1] if len(sys.argv) > 1 else None
    for sql_file in sorted(QUERY_DIR.glob("*.sql")):
        if wanted is None or sql_file.stem == wanted:
            run_file(sql_file)


if __name__ == "__main__":
    main()
