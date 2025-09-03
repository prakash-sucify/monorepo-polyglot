from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
import openai
import os
from dotenv import load_dotenv
import logging

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="AI Service",
    description="AI service with OpenAI integration",
    version="1.0.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize OpenAI client
openai.api_key = os.getenv("OPENAI_API_KEY")

# Pydantic models
class ChatMessage(BaseModel):
    role: str
    content: str

class ChatRequest(BaseModel):
    messages: List[ChatMessage]
    model: Optional[str] = "gpt-3.5-turbo"
    max_tokens: Optional[int] = 1000
    temperature: Optional[float] = 0.7

class ChatResponse(BaseModel):
    response: str
    model: str
    usage: Optional[dict] = None

class TextGenerationRequest(BaseModel):
    prompt: str
    model: Optional[str] = "gpt-3.5-turbo"
    max_tokens: Optional[int] = 500
    temperature: Optional[float] = 0.7

class TextGenerationResponse(BaseModel):
    generated_text: str
    model: str
    usage: Optional[dict] = None

class SummarizationRequest(BaseModel):
    text: str
    max_length: Optional[int] = 150
    model: Optional[str] = "gpt-3.5-turbo"

class SummarizationResponse(BaseModel):
    summary: str
    original_length: int
    summary_length: int

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "AI Service API",
        "version": "1.0.0",
        "endpoints": [
            "GET /health - Health check",
            "POST /chat - Chat with AI",
            "POST /generate - Generate text",
            "POST /summarize - Summarize text",
            "GET /models - List available models"
        ]
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "ai-service",
        "version": "1.0.0"
    }

@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """Chat with AI using OpenAI API"""
    try:
        # Convert messages to OpenAI format
        messages = [{"role": msg.role, "content": msg.content} for msg in request.messages]
        
        # Call OpenAI API
        response = openai.ChatCompletion.create(
            model=request.model,
            messages=messages,
            max_tokens=request.max_tokens,
            temperature=request.temperature
        )
        
        return ChatResponse(
            response=response.choices[0].message.content,
            model=response.model,
            usage=response.usage.dict() if response.usage else None
        )
        
    except Exception as e:
        logger.error(f"Error in chat endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/generate", response_model=TextGenerationResponse)
async def generate_text(request: TextGenerationRequest):
    """Generate text using OpenAI API"""
    try:
        response = openai.Completion.create(
            model=request.model,
            prompt=request.prompt,
            max_tokens=request.max_tokens,
            temperature=request.temperature
        )
        
        return TextGenerationResponse(
            generated_text=response.choices[0].text,
            model=response.model,
            usage=response.usage.dict() if response.usage else None
        )
        
    except Exception as e:
        logger.error(f"Error in generate endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/summarize", response_model=SummarizationResponse)
async def summarize_text(request: SummarizationRequest):
    """Summarize text using OpenAI API"""
    try:
        prompt = f"Please summarize the following text in {request.max_length} words or less:\n\n{request.text}"
        
        response = openai.Completion.create(
            model=request.model,
            prompt=prompt,
            max_tokens=request.max_length + 50,  # Add buffer for response
            temperature=0.3  # Lower temperature for more consistent summaries
        )
        
        summary = response.choices[0].text.strip()
        
        return SummarizationResponse(
            summary=summary,
            original_length=len(request.text),
            summary_length=len(summary)
        )
        
    except Exception as e:
        logger.error(f"Error in summarize endpoint: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/models")
async def list_models():
    """List available OpenAI models"""
    try:
        models = openai.Model.list()
        return {
            "models": [model.id for model in models.data],
            "count": len(models.data)
        }
    except Exception as e:
        logger.error(f"Error listing models: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PORT", 8082))
    uvicorn.run(app, host="0.0.0.0", port=port)
