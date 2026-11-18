# Class 2: Bash scripting

## Goal

Understand how the Ubuntu setup and demo launcher automate repeatable project
tasks.

## Scripts in this project

- `setup_ubuntu.sh` installs Ubuntu prerequisites, Python 3.12, and the locked
  Python dependencies.
- `run_demo_sqllite.sh` starts the SQLite Streamlit demo using `.venv`.

Both scripts find the project directory from their own file location, so they
can be called from another working directory:

```bash
bash /path/to/Text-to-SQL-Chatbot/setup_ubuntu.sh
bash /path/to/Text-to-SQL-Chatbot/run_demo_sqllite.sh
```

## Read the setup script

Notice how `setup_ubuntu.sh` uses:

- `set -Eeuo pipefail` to stop on command and pipeline failures.
- `/etc/os-release` to check the operating system.
- `sudo apt-get` for system prerequisites when not run as root.
- `uv python install 3.12` and `uv sync --frozen` for a reproducible Python
  environment.

## Validate and practice

Check Bash syntax before running a changed script:

```bash
bash -n setup_ubuntu.sh
bash -n run_demo_sqllite.sh
```

If ShellCheck is installed, lint both scripts:

```bash
shellcheck setup_ubuntu.sh run_demo_sqllite.sh
```

Exercise: add a clear error message for a missing required file, run the
syntax check, and verify that the script exits with a non-zero status for that
case.
