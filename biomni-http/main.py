from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from openai.types.responses import Response
from openai import OpenAI
from biomni.agent import A1
from typing import AsyncGenerator 
from pydantic import BaseModel


class Query(BaseModel):
    model: str
    prompt: str

app = FastAPI()
 
@app.get("/")
async def root():
    return {"message": "Biomni HTTP API is running!"}

@app.post("/a1/", response_model=None)
def a1(query: Query) -> StreamingResponse:
    """
    Stream responses from the A1 agent based on the given Query object.

    Args:
        query (Query): The request body containing the model (str) and prompt (str) to use.
    """
    provider, model_spec =query.model.split('/', 1)
    source = {
        "openai": "OpenAI",
        "azure": "AzureOpenAI",
        "anthropic": "Anthropic",
        "xai": "Groq",
        "ollama": "Ollama",
        "bedrock": "Bedrock"
    }[provider]

    agent = A1(path='/Biomni/data', llm=model_spec, source=source, use_tool_retriever=True)

    async def go_stream(prompt: str) -> AsyncGenerator[str, None]:
        for chunk in agent.go_stream(prompt):
            yield chunk["output"]

    return StreamingResponse(go_stream(query.prompt))

