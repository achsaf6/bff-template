from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import os

app = FastAPI(
    title="Backend",
    description="Backend API for an application",
    version="0.1.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Mount static files
app.mount("/static", StaticFiles(directory=f"{BASE_DIR}/frontend/build/static"), name="static")

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "backend"} 

@app.get("/{full_path:path}")
async def serve_frontend(full_path: str):
    """Serve frontend static files"""
    # First try to serve the exact file if it exists
    file_path = os.path.join(f"{BASE_DIR}/frontend/build", full_path)
    if os.path.isfile(file_path):
        return FileResponse(file_path)
    
    # Otherwise serve index.html for client-side routing
    return FileResponse(f"{BASE_DIR}/frontend/build/index.html")
