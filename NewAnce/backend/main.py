from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from api import articles, keywords, bias, question

app = FastAPI(title="NewAnce API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(articles.router, prefix="/api/articles", tags=["articles"])
app.include_router(keywords.router, prefix="/api/keywords", tags=["keywords"])
app.include_router(bias.router, prefix="/api/bias", tags=["bias"])
app.include_router(question.router, prefix="/api/question", tags=["question"])
