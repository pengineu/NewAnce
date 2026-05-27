from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from pipeline.question_generator import generate_question, calculate_bias_score
from models.user import UserHistory

router = APIRouter()

@router.get("/generate")
def get_question(user_id: int = 1, db: Session = Depends(get_db)):
    history = db.query(UserHistory).filter(UserHistory.user_id == user_id).all()
    history_dicts = [{"perspective": h.perspective, "keyword": h.top_keyword} for h in history]

    if not history_dicts:
        return {"question": None}

    top_keyword = max(set([h["keyword"] for h in history_dicts]), key=lambda k: sum(1 for h in history_dicts if h["keyword"] == k))
    question = generate_question(history_dicts, top_keyword)
    return {"question": question}
