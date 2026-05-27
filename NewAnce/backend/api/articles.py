from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from models.article import Article

router = APIRouter()

@router.get("/{article_id}")
def get_article(article_id: int, db: Session = Depends(get_db)):
    article = db.query(Article).filter(Article.id == article_id).first()
    return article

@router.get("/")
def get_articles(category: str = "politics", skip: int = 0, limit: int = 20, db: Session = Depends(get_db)):
    articles = db.query(Article).filter(Article.category == category).offset(skip).limit(limit).all()
    return articles
