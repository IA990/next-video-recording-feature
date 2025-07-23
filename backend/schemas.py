from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class PhotoBase(BaseModel):
    url: str

class PhotoCreate(PhotoBase):
    pass

class Photo(PhotoBase):
    id: int

    class Config:
        orm_mode = True

class OfferBase(BaseModel):
    title: str
    description: Optional[str] = None
    valid_until: Optional[datetime] = None

class OfferCreate(OfferBase):
    pass

class Offer(OfferBase):
    id: int

    class Config:
        orm_mode = True

class ReviewBase(BaseModel):
    rating: int
    comment: Optional[str] = None

class ReviewCreate(ReviewBase):
    professional_id: int

class ReviewOut(ReviewBase):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True

class ProfessionalBase(BaseModel):
    name: str
    type: str
    phone: str
    email: Optional[str] = None
    description: Optional[str] = None
    working_hours: Optional[str] = None
    location: Optional[str] = None
    latitude: float
    longitude: float
    photo_url: Optional[str] = None

class ProfessionalCreate(ProfessionalBase):
    pass

class ProfessionalUpdate(BaseModel):
    name: Optional[str] = None
    type: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    description: Optional[str] = None
    working_hours: Optional[str] = None
    location: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    photo_url: Optional[str] = None

class Professional(ProfessionalBase):
    id: int
    reviews: List[ReviewOut] = []
    photos: List[Photo] = []
    offers: List[Offer] = []

    class Config:
        orm_mode = True
