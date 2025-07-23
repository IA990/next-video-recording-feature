from fastapi import APIRouter, Depends, File, UploadFile, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from backend import database, auth_utils, crud, models
import os
from uuid import uuid4
from typing import List
from fastapi.responses import FileResponse

router = APIRouter()

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    username = auth_utils.verify_token(token, credentials_exception)
    user = crud.get_user_by_username(db, username=username)
    if user is None:
        raise credentials_exception
    return user

UPLOAD_DIR = "backend/uploads/videos"
os.makedirs(UPLOAD_DIR, exist_ok=True)

ALLOWED_EXTENSIONS = {".mp4", ".mov", ".avi", ".mkv"}

def allowed_file(filename: str) -> bool:
    ext = os.path.splitext(filename)[1].lower()
    return ext in ALLOWED_EXTENSIONS

@router.post("/upload", status_code=201)
async def upload_video(file: UploadFile = File(...), current_user: models.User = Depends(get_current_user)):
    if not allowed_file(file.filename):
        raise HTTPException(status_code=400, detail="Unsupported file type")
    file_id = str(uuid4())
    filename = f"{file_id}{os.path.splitext(file.filename)[1]}"
    file_path = os.path.join(UPLOAD_DIR, filename)
    try:
        with open(file_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save file: {str(e)}")
    # Optionally, save file metadata to DB here
    return {"file_id": file_id, "filename": filename}

@router.get("/{file_id}")
def get_video(file_id: str):
    # Search for file in upload directory by file_id prefix
    for fname in os.listdir(UPLOAD_DIR):
        if fname.startswith(file_id):
            file_path = os.path.join(UPLOAD_DIR, fname)
            return FileResponse(file_path, media_type="video/mp4", filename=fname)
    raise HTTPException(status_code=404, detail="File not found")
