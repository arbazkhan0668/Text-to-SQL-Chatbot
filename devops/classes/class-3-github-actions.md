# Class 3: GitHub Actions

## Goal

Run automatic checks when this project receives a push or pull request.

## Add a CI workflow

Create `.github/workflows/ci.yml` in the repository with:

```yaml
name: Project checks

on:
  push:
  pull_request:

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Check out the repository
        uses: actions/checkout@v4

      - name: Install uv
        uses: astral-sh/setup-uv@v6
        with:
          enable-cache: true

      - name: Install locked dependencies
        run: |
          uv python install 3.12
          uv sync --frozen --no-install-project --python 3.12

      - name: Check Python syntax
        run: |
          .venv/bin/python -m compileall -q \
            app main.py demo.py demo_sqllite.py sql_lite_datacreate.py
```

Commit and push the workflow, then open a pull request and inspect the
**Actions** tab on GitHub. This project currently has no automated test suite,
so the workflow verifies dependency installation and Python syntax; it does
not verify live AI-provider or MySQL access.

## Exercise

Create a branch, add the workflow, and confirm the check runs successfully
before merging. Do not add API keys as workflow variables for this syntax-only
check.
