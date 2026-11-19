@echo off
setlocal

REM Resolve the project root so the launcher works from any directory.
set "PROJECT_DIR=%~dp0"
if "%PROJECT_DIR:~-1%"=="\" set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"

set "APP_FILE=%PROJECT_DIR%\demo_sqllite.py"
set "PYTHON=%PROJECT_DIR%\.venv\Scripts\python.exe"

REM Require the Windows virtual environment to be present.
if not exist "%PYTHON%" (
    echo Python environment not found. Create the .venv virtual environment first. >&2
    exit /b 1
)

if not exist "%APP_FILE%" (
    echo SQLite demo not found: %APP_FILE% >&2
    exit /b 1
)

REM Run Streamlit from the project directory so project files and .env are found.
cd /d "%PROJECT_DIR%"
"%PYTHON%" -m streamlit run "%APP_FILE%"
