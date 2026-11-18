# Class 5: Docker

## Goal

Build an image for the main Streamlit app and run it locally in a container.

## Create a Dockerfile

Add a `Dockerfile` at the project root:

```dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8501

CMD ["python", "-m", "streamlit", "run", "main.py", \
     "--server.address=0.0.0.0", "--server.port=8501"]
```

Add a `.dockerignore` file at the project root so local secrets, environments,
and large development files are not copied into the image:

```text
.git
.venv
__pycache__
*.py[cod]
.env
*.ipynb
*.rar
```

Keep `uber.db` out of `.dockerignore`; Demo mode needs this bundled SQLite
database.

## Build and run

Create a local `.env` containing the provider key, then build and run:

```bash
docker build -t text-to-sql:local .
docker run --rm --name text-to-sql \
  --env-file .env \
  -p 127.0.0.1:8501:8501 \
  text-to-sql:local
```

Open `http://127.0.0.1:8501` on the Docker host. The port is deliberately
bound to localhost; use an authenticated HTTPS reverse proxy for remote
access. Do not put `.env` in the image or commit it.

## Exercise

Build the image, start the container, test Demo mode, and stop it with
`Ctrl+C`. Then rebuild after a small code change and confirm the image starts
again.
