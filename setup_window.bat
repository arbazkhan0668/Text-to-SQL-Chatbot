@echo off
setlocal

echo === Starting Project Setup ===

REM 1. Check if we are in the right project folder
if not exist "pyproject.toml" (
    echo Error: Please run this script inside the project folder containing pyproject.toml and uv.lock.
    exit /b 1
)
if not exist "uv.lock" (
    echo Error: Please run this script inside the project folder containing pyproject.toml and uv.lock.
    exit /b 1
)

REM 2. Check if the OS is Windows
if /i not "%OS%"=="Windows_NT" (
    echo Error: This script is built for Windows only.
    exit /b 1
)

REM 3. Prerequisites check (Windows has built-in certificates and curl on Win10/11)
echo [1/3] Checking system prerequisites...

REM 4. Install 'uv' (Python package manager) if not already installed
set "PATH=%USERPROFILE%\.local\bin;%PATH%"

where uv >nul 2>&1
if %errorlevel% neq 0 (
    echo [2/3] Installing uv...
    set "UV_NO_MODIFY_PATH=1"
    set "UV_INSTALL_DIR=%USERPROFILE%\.local\bin"
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh | iex"
    if %errorlevel% neq 0 (
        echo Error: Failed to install uv.
        exit /b 1
    )
) else (
    echo [2/3] uv is already installed. Skipping...
)

REM 5. Install Python 3.12 via uv
echo [3/3] Installing Python 3.12 and syncing dependencies...
uv python install 3.12
if %errorlevel% neq 0 (
    echo Error: Failed to install Python 3.12.
    exit /b 1
)

REM 6. Create virtual environment and install project dependencies
uv sync --frozen --no-install-project --python 3.12
if %errorlevel% neq 0 (
    echo Error: Failed to sync project dependencies.
    exit /b 1
)

echo.
echo === Setup Complete! ===
echo Next steps:
echo   1. (for Windows) Activate environment: .venv\Scripts\activate
echo   2. Add your API key to the .env file
echo   3. Start the app:          streamlit run main.py
