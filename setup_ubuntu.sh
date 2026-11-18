#!/usr/bin/env bash
# Stop on errors, unset variables, and failed commands in a pipeline.
set -Eeuo pipefail

# Resolve the project root from this script so it can be run from any directory.
PROJECT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# Read Ubuntu's release metadata before using Ubuntu-specific package commands.
if [[ ! -f /etc/os-release ]]; then
    echo "Cannot identify the operating system; this script supports Ubuntu." >&2
    exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release
if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "This script supports Ubuntu only (detected: ${ID:-unknown})." >&2
    exit 1
fi

# Make sure the script is running in this project's root directory.
if [[ ! -f pyproject.toml || ! -f uv.lock ]]; then
    echo "Run this script from a project checkout containing pyproject.toml and uv.lock." >&2
    exit 1
fi

# Use apt directly as root, or through sudo for a regular user.
if (( EUID == 0 )); then
    APT_GET=(apt-get)
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo is required to install Ubuntu system packages." >&2
        exit 1
    fi
    APT_GET=(sudo apt-get)
fi

# Install curl for downloading uv and build tools for dependencies that need compilation.
echo "Installing Ubuntu prerequisites..."
"${APT_GET[@]}" update
"${APT_GET[@]}" install -y --no-install-recommends ca-certificates curl build-essential

# Add uv's default install directory for this script's current session.
export PATH="$HOME/.local/bin:$PATH"
if ! command -v uv >/dev/null 2>&1; then
    echo "Installing uv..."
    # Keep the installer from changing shell startup files.
    export UV_NO_MODIFY_PATH=1
    export UV_INSTALL_DIR="$HOME/.local/bin"
    curl --fail --silent --show-error --location https://astral.sh/uv/install.sh | sh
    export PATH="$UV_INSTALL_DIR:$PATH"
fi

# Install Python in uv's managed directory without replacing Ubuntu's system Python.
echo "Installing Python 3.12..."
uv python install 3.12

# Create/update .venv from the committed lockfile; the project itself is run as scripts.
echo "Creating the project environment and installing locked dependencies..."
uv sync --frozen --no-install-project --python 3.12

# Print the next steps; users must supply their own AI provider API key.
echo
echo "Setup complete."
echo "Activate the environment with: source .venv/bin/activate"
echo "Run the app with: streamlit run main.py"
echo "Add a provider API key to .env before generating SQL."
