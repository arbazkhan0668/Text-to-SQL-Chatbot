#!/usr/bin/env bash
set -Eeuo pipefail

# Resolve the project root so the launcher works from any directory.
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
APP_FILE="$PROJECT_DIR/demo_sqllite.py"
PYTHON="$PROJECT_DIR/.venv/bin/python"

# Require the environment created by the Ubuntu setup script.
if [[ ! -x "$PYTHON" ]]; then
    echo "Python environment not found. Run 'bash setup_ubuntu.sh' first." >&2
    exit 1
fi

if [[ ! -f "$APP_FILE" ]]; then
    echo "SQLite demo not found: $APP_FILE" >&2
    exit 1
fi

# Run Streamlit from the project directory so project files and .env are found.
cd "$PROJECT_DIR"
exec "$PYTHON" -m streamlit run "$APP_FILE"
