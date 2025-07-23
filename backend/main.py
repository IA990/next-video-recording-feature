from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from backend.routers import professionals, reviews, auth, notifications
from backend.database import engine
from backend import models

# Create all tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="MaBoutique API")

# Allow CORS for Flutter app (adjust origins as needed)
origins = [
    "http://localhost",
    "http://localhost:8000",
    "http://10.0.2.2",  # Android emulator localhost
    "http://127.0.0.1",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(professionals.router, prefix="/professionals", tags=["professionals"])
app.include_router(reviews.router, prefix="/reviews", tags=["reviews"])
app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(notifications.router, prefix="/notifications", tags=["notifications"])
from backend.routers import videos
app.include_router(videos.router, prefix="/videos", tags=["videos"])
