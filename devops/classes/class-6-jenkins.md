# Class 6: Jenkins

## Goal

Use Jenkins to check changes to this project with a pipeline running on an
Ubuntu agent.

## Prepare Jenkins

Use an Ubuntu Jenkins agent with Git, `uv`, and build tools installed. The
agent also needs network access to download Python and packages. Create a
Pipeline job that loads a `Jenkinsfile` from this repository's branch.

## Add a Jenkinsfile

Create `Jenkinsfile` at the project root:

```groovy
pipeline {
    agent any

    stages {
        stage('Install dependencies') {
            steps {
                sh '''
                    set -eu
                    uv python install 3.12
                    uv sync --frozen --no-install-project --python 3.12
                '''
            }
        }

        stage('Check Python syntax') {
            steps {
                sh '''
                    .venv/bin/python -m compileall -q \
                      app main.py demo.py demo_sqllite.py sql_lite_datacreate.py
                '''
            }
        }
    }
}
```

Run the job and review its console output. This pipeline performs dependency
and syntax checks; it does not deploy the app or need AI-provider credentials.

## Exercise

Run the pipeline for a feature branch and confirm it fails if a Python syntax
error is introduced, then fix the error and rerun it.

For a future deployment stage, store credentials in Jenkins' Credentials
Store, add an approval step, and deploy only from a reviewed branch. Never
hard-code API keys or database passwords in the `Jenkinsfile`.
