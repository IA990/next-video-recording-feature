from sqlalchemy.orm import Session
from backend import models, schemas
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_user_by_username(db: Session, username: str):
    return db.query(models.User).filter(models.User.username == username).first()

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate):
    hashed_password = pwd_context.hash(user.password)
    db_user = models.User(
        username=user.username,
        email=user.email,
        hashed_password=hashed_password,
        is_active=True,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def authenticate_user(db: Session, username: str, password: str):
    user = get_user_by_username(db, username)
    if not user:
        return False
    if not verify_password(password, user.hashed_password):
        return False
    return user

# Existing CRUD functions for professionals and reviews remain unchanged
def get_professionals(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Professional).offset(skip).limit(limit).all()

def get_professional(db: Session, professional_id: int):
    return db.query(models.Professional).filter(models.Professional.id == professional_id).first()

def create_professional(db: Session, professional: schemas.ProfessionalCreate):
    db_professional = models.Professional(
        name=professional.name,
        type=professional.type,
        phone=professional.phone,
        location=professional.location,
        latitude=professional.latitude,
        longitude=professional.longitude,
        photo_url=professional.photo_url,
    )
    db.add(db_professional)
    db.commit()
    db.refresh(db_professional)
    return db_professional

def get_reviews_by_professional(db: Session, professional_id: int):
    return db.query(models.Review).filter(models.Review.professional_id == professional_id).all()

def create_review(db: Session, review: schemas.ReviewCreate):
    db_review = models.Review(
        professional_id=review.professional_id,
        rating=review.rating,
        comment=review.comment,
    )
    db.add(db_review)
    db.commit()
    db.refresh(db_review)
    return db_review
