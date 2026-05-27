from sqlalchemy import Column, Integer, String, Text, DateTime, JSON
from sqlalchemy.sql import func
from db.database import Base

class Article(Base):
    __tablename__ = "articles"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(500), nullable=False)
    body = Column(Text)
    summary = Column(String(300))
    press = Column(String(100))
    link = Column(String(500), unique=True)
    perspective = Column(String(10))   # 진보 / 중립 / 보수
    category = Column(String(50), default="politics")
    keywords = Column(JSON, default={})
    created_at = Column(DateTime, server_default=func.now())
