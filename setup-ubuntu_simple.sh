#!/bin/bash

# Exit immediately if any command fails
set -e

echo "=== Starting Project Setup ==="

# 1. Check if we are in the right project folder
if [ ! -f "pyproject.toml" ] || [ ! -f "uv.lock" ]; then
    echo "Error: Please run this script inside the project folder containing pyproject.toml and uv.lock."
    exit 1
fi

# 2. Check if the OS is Ubuntu
if ! grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
    echo "Error: This script is built for Ubuntu only."
    exit 1
fi

# 3. Install required system packages
echo "[1/4] Updating system and installing prerequisites..."
sudo apt-get update
sudo apt-get install -y ca-certificates curl build-essential

# 4. Install 'uv' (Python package manager) if not already installed
export PATH="$HOME/.local/bin:$PATH"

if ! command -v uv >/dev/null 2>&1; then
    echo "[2/4] Installing uv..."
    export UV_NO_MODIFY_PATH=1
    export UV_INSTALL_DIR="$HOME/.local/bin"
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "[2/4] uv is already installed. Skipping..."
fi

# 5. Install Python 3.12 via uv
echo "[3/4] Installing Python 3.12..."
uv python install 3.12

# 6. Create virtual environment and install project dependencies
echo "[4/4] Setting up virtual environment and installing dependencies..."
uv sync --frozen --no-install-project --python 3.12

echo ""
echo "=== Setup Complete! ==="
echo "Next steps:"
echo "  1. Activate environment: source .venv/bin/activate"
echo "  2. Add your API key to the .env file"
echo "  3. Start the app:        streamlit run main.py"
