# Biomni FastAPI backend service

This FastAPI service exposes the Biomni streaming API as an HTTP service. 

## Features

- **ChatKit endpoint** at `POST /chatkit` that streams responses using the ChatKit protocol when the optional ChatKit Python package is installed.
- **Fact recording tool** that renders a confirmation widget with _Save_ and _Discard_ actions.
- **Guardrail-ready system prompt** extracted into `app/constants.py` so it is easy to modify.
- **Simple fact store** backed by in-memory storage in `app/facts.py`.
- **REST helpers**
  - `GET  /facts` – list saved facts (used by the frontend list view)
  - `POST /facts/{fact_id}/save` – mark a fact as saved
  - `POST /facts/{fact_id}/discard` – discard a pending fact
  - `GET  /health` – surface a basic health indicator

## Getting started

Create a `credentials.env` file (which will be ignored by `.gitignore`) and add your API keys:

### Required (?): Anthropic API Key for Claude models
ANTHROPIC_API_KEY=your_anthropic_api_key_here

### Optional: OpenAI API Key (if using OpenAI models)
OPENAI_API_KEY=your_openai_api_key_here

### Optional: AWS Bedrock Configuration (if using AWS Bedrock models)
AWS_BEARER_TOKEN_BEDROCK=your_bedrock_api_key_here
AWS_REGION=us-east-1


```bash
uv sync
export OPENAI_API_KEY=sk-proj-...
uv run uvicorn app.main:app --reload
```
