from apscheduler.schedulers.background import BackgroundScheduler
from crawler.naver_news import crawl_naver_news
from pipeline.classifier import classify_perspective
from pipeline.keyword_extractor import extract_keywords
from pipeline.summarizer import summarize_article
from db.database import SessionLocal
from models.article import Article

def crawl_and_process():
    db = SessionLocal()
    articles = crawl_naver_news()
    for raw in articles:
        perspective = classify_perspective(raw["title"], raw.get("body", ""), raw.get("media_bias"))
        keywords = extract_keywords(raw["title"], raw.get("body", ""))
        summary = summarize_article(raw["title"], raw.get("body", ""))
        article = Article(
            title=raw["title"],
            body=raw.get("body", ""),
            summary=summary,
            press=raw["press"],
            link=raw["link"],
            perspective=perspective["perspective"],
            keywords=keywords,
        )
        db.add(article)
    db.commit()
    db.close()

def start_scheduler():
    scheduler = BackgroundScheduler()
    scheduler.add_job(crawl_and_process, "interval", minutes=30)
    scheduler.start()
