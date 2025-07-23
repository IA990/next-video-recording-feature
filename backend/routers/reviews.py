from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from backend import crud, schemas, database

router = APIRouter()

# Dependency to get DB session
def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.ReviewOut)
def create_review(review: schemas.ReviewCreate, db: Session = Depends(get_db)):
    return crud.create_review(db=db, review=review)

@router.get("/professional/{professional_id}", response_model=List[schemas.ReviewOut])
def get_reviews_for_professional(professional_id: int, db: Session = Depends(get_db)):
    reviews = crud.get_reviews_by_professional(db, professional_id=professional_id)
    if reviews is None:
        raise HTTPException(status_code=404, detail="Reviews not found")
    return reviews
