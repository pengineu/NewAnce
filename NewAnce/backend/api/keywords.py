from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from models.article import Article

router = APIRouter()

@router.get("/{keyword}")
def get_keyword_page(keyword: str, db: Session = Depends(get_db)):
    articles = db.query(Article).filter(Article.keywords.contains([keyword])).all()
    counts = {"진보": 0, "중립": 0, "보수": 0}
    for a in articles:
        counts[a.perspective] += 1
    return {
        "keyword": keyword,
        "distribution": counts,
        "total": len(articles),
        "articles": articles
    }
