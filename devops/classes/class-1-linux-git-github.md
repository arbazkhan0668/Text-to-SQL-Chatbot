# Class 1: Linux, Git, and GitHub

## Goal

Use an Ubuntu terminal to inspect, run, version, and share this Text-to-SQL
project.

## Linux practice

From the project directory:

```bash
pwd
ls -la
cd app
cd ..
git status
```

`pwd` shows the current directory, `ls` lists files, and `cd` changes
directories. The project root contains `main.py`, `app/`, `uber.db`,
`requirements.txt`, and `uv.lock`.

Run the app after setup:

```bash
bash setup_ubuntu.sh
bash run_demo_sqllite.sh
```

## Git and GitHub practice

Create a feature branch, make a small project change, and inspect it before
sharing:

```bash
git switch -c feature/devops-practice
git status
git diff
git add <your-changed-file>
git commit -m "Document DevOps practice"
git push -u origin feature/devops-practice
```

Replace `<your-changed-file>` with the path you actually changed. Open a pull
request on GitHub so the change can be reviewed before merging.

## Project safety checks

- Check `git status` before staging so unrelated files are not included.
- `.env` and `.venv` are ignored by Git; verify with `git check-ignore .env .venv`.
- Never commit API keys, database passwords, or generated local secrets.

## Exercise

Create a branch, update a project document with a useful setup note, review
the diff, and open a pull request.
