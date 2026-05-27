from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.database import get_db
from models.user import UserHistory

router = APIRouter()

@router.get("/me")
def get_my_bias(user_id: int = 1, db: Session = Depends(get_db)):
    history = db.query(UserHistory).filter(UserHistory.user_id == user_id).all()
    counts = {"진보": 0, "중립": 0, "보수": 0}
    for h in history:
        counts[h.perspective] += 1
    total = len(history)
    dominant = max(counts, key=counts.get) if total > 0 else None
    score = counts[dominant] / total if total > 0 else 0
    return {"counts": counts, "total": total, "dominant": dominant, "score": score}
