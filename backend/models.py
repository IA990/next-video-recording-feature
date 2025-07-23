from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime, Text, func, Table
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

# Association table for professional photos
professional_photos = Table(
    'professional_photos',
    Base.metadata,
    Column('professional_id', Integer, ForeignKey('professionals.id')),
    Column('photo_id', Integer, ForeignKey('photos.id'))
)

class Photo(Base):
    __tablename__ = 'photos'

    id = Column(Integer, primary_key=True, index=True)
    url = Column(String, nullable=False)
    professional_id = Column(Integer, ForeignKey('professionals.id'))

class Offer(Base):
    __tablename__ = 'offers'

    id = Column(Integer, primary_key=True, index=True)
    professional_id = Column(Integer, ForeignKey('professionals.id'))
    title = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    valid_until = Column(DateTime, nullable=True)

class Professional(Base):
    __tablename__ = "professionals"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    name = Column(String, index=True, nullable=False)
    type = Column(String, index=True, nullable=False)
    phone = Column(String, nullable=False)
    email = Column(String, nullable=True)
    description = Column(Text, nullable=True)
    working_hours = Column(String, nullable=True)
    location = Column(String, nullable=True)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    photo_url = Column(String, nullable=True)

    user = relationship("User", back_populates="professional")
    reviews = relationship("Review", back_populates="professional", cascade="all, delete-orphan")
    photos = relationship("Photo", backref="professional", cascade="all, delete-orphan")
    offers = relationship("Offer", backref="professional", cascade="all, delete-orphan")
