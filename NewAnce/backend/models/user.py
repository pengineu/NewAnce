from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.sql import func
from db.database import Base

class UserHistory(Base):
    __tablename__ = "user_history"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    article_id = Column(Integer, ForeignKey("articles.id"))
    perspective = Column(String(10))
    top_keyword = Column(String(100))
    read_at = Column(DateTime, server_default=func.now())
