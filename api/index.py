from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from . import logic
import os

app = FastAPI(
    title="Stock-Spotter API",
    description="Real-time global inventory & trend detection API.",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/inventory")
async def get_inventory():
    """Returns all current inventory items tracked globally."""
    return logic.load_inventory()

@app.get("/api/trends")
async def get_trends():
    """Returns only items that are currently trending based on AI analysis."""
    return logic.get_trending_items()

@app.get("/api/health")
async def health_check():
    return {"status": "active", "service": "Stock-Spotter Engine"}

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

@app.get("/", include_in_schema=False)
async def read_root():
    """Serves the landing page."""
    return FileResponse(os.path.join(BASE_DIR, "index.html"))

@app.get("/style.css", include_in_schema=False)
async def get_style():
    return FileResponse(os.path.join(BASE_DIR, "style.css"))

@app.get("/hero.png", include_in_schema=False)
async def get_hero():
    return FileResponse(os.path.join(BASE_DIR, "hero.png"))

@app.get("/inventory.json", include_in_schema=False)
async def get_inventory_json():
    return FileResponse(os.path.join(BASE_DIR, "inventory.json"))
