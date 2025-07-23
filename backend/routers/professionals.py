from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from fastapi.security import OAuth2PasswordBearer
from backend import crud, schemas, database, models, auth_utils

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

@router.get("/", response_model=List[schemas.Professional])
def read_professionals(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    professionals = crud.get_professionals(db, skip=skip, limit=limit)
    return professionals

@router.post("/", response_model=schemas.Professional)
def create_professional(professional: schemas.ProfessionalCreate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    # Only authenticated users can create professionals
    return crud.create_professional(db=db, professional=professional)

@router.get("/{professional_id}", response_model=schemas.Professional)
def read_professional(professional_id: int, db: Session = Depends(get_db)):
    db_professional = crud.get_professional(db, professional_id=professional_id)
    if db_professional is None:
        raise HTTPException(status_code=404, detail="Professional not found")
    return db_professional

@router.put("/{professional_id}", response_model=schemas.Professional)
def update_professional(professional_id: int, professional_update: schemas.ProfessionalUpdate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    db_professional = crud.get_professional(db, professional_id=professional_id)
    if db_professional is None:
        raise HTTPException(status_code=404, detail="Professional not found")
    # Check ownership
    if db_professional.user_id != current_user.id:
        raise HTTPException(status_code=403, detail="Not authorized to update this professional")
    # Update fields
    for var, value in vars(professional_update).items():
        if value is not None:
            setattr(db_professional, var, value)
    db.commit()
    db.refresh(db_professional)
    return db_professional
