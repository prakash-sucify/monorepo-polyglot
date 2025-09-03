from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI(
    title="AI Service API",
    description="AI and Machine Learning service for the monorepo",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {
        "message": "AI Service API",
        "version": "1.0.0",
        "endpoints": [
            "GET /health - Health check",
            "POST /ai/analyze - Analyze text",
            "POST /ai/summarize - Summarize content",
        ]
    }

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "service": "ai-service"
    }

@app.post("/ai/analyze")
async def analyze_text(text: str):
    # Placeholder for AI analysis
    return {
        "text": text,
        "analysis": "This is a placeholder for AI analysis",
        "sentiment": "positive",
        "confidence": 0.85
    }

@app.post("/ai/summarize")
async def summarize_content(content: str):
    # Placeholder for AI summarization
    return {
        "original": content,
        "summary": "This is a placeholder for AI summarization",
        "word_count": len(content.split())
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8082)
