#!/bin/bash

# NewAnce 더미 파일 생성 스크립트
mkdir -p NewAnce/{frontend/public,frontend/src/{components/{common,home,article,keyword},pages,hooks,store},backend/{api,crawler,pipeline,models,db}}

# ─────────────────────────────────────────
# FRONTEND
# ─────────────────────────────────────────

cat > NewAnce/frontend/src/components/common/Header.tsx << 'EOF'
import React from "react";
import SearchBar from "./SearchBar";

const Header = () => {
  return (
    <header className="flex items-center px-6 py-3 bg-gray-900 text-white">
      <h1 className="text-xl font-bold mr-4 cursor-pointer">뉴앙스</h1>
      <SearchBar />
    </header>
  );
};

export default Header;
EOF

cat > NewAnce/frontend/src/components/common/SearchBar.tsx << 'EOF'
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

const SearchBar = () => {
  const [query, setQuery] = useState("");
  const navigate = useNavigate();

  const handleSearch = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && query.trim()) {
      navigate(`/keyword/${query.trim()}`);
    }
  };

  return (
    <input
      type="text"
      placeholder="키워드로 다양한 관점 찾기"
      value={query}
      onChange={(e) => setQuery(e.target.value)}
      onKeyDown={handleSearch}
      className="w-full px-4 py-2 rounded-full bg-white text-gray-800 outline-none"
    />
  );
};

export default SearchBar;
EOF

cat > NewAnce/frontend/src/components/home/HotTopic.tsx << 'EOF'
import React from "react";

interface Topic {
  rank: number;
  keyword: string;
  count: number;
  trend: "up" | "down" | "same";
}

interface Props {
  topics: Topic[];
}

const HotTopic = ({ topics }: Props) => {
  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <h2 className="font-bold text-lg mb-3">실시간 국내 Hot Topic</h2>
      {topics.map((topic) => (
        <div key={topic.rank} className="flex items-center py-2 border-b last:border-none">
          <span className="w-6 text-gray-500 font-bold">{topic.rank}</span>
          <span className="flex-1 font-medium">{topic.keyword}</span>
          <span className="text-sm text-gray-400">{topic.count.toLocaleString()}건</span>
        </div>
      ))}
    </div>
  );
};

export default HotTopic;
EOF

cat > NewAnce/frontend/src/components/home/BiasChart.tsx << 'EOF'
import React from "react";
import { PieChart, Pie, Cell, Legend } from "recharts";

interface Props {
  data: { name: string; value: number }[];
  totalCount: number;
}

const COLORS = { 진보: "#4A90D9", 중립: "#9B9B9B", 보수: "#E05C5C" };

const BiasChart = ({ data, totalCount }: Props) => {
  if (totalCount < 5) {
    return (
      <div className="flex flex-col items-center justify-center h-48 text-gray-400">
        <p className="text-lg font-medium">아직 읽은 기사가 없습니다</p>
        <p className="text-sm">기사를 클릭하여 읽기 시작하면 관점 분포가 표시됩니다</p>
      </div>
    );
  }

  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <div className="flex justify-between items-center mb-2">
        <h2 className="font-bold text-lg">내가 본 기사 관점 분포</h2>
        <span className="text-sm text-gray-500">읽은 기사: {totalCount}개</span>
      </div>
      <PieChart width={300} height={200}>
        <Pie data={data} cx={100} cy={100} outerRadius={80} dataKey="value">
          {data.map((entry) => (
            <Cell key={entry.name} fill={COLORS[entry.name as keyof typeof COLORS]} />
          ))}
        </Pie>
        <Legend />
      </PieChart>
    </div>
  );
};

export default BiasChart;
EOF

cat > NewAnce/frontend/src/components/article/ArticleBody.tsx << 'EOF'
import React from "react";
import { useNavigate } from "react-router-dom";

interface Props {
  body: string;
  keywords: { word: string; type: string }[];
}

const ArticleBody = ({ body, keywords }: Props) => {
  const navigate = useNavigate();

  const highlightKeywords = (text: string) => {
    let result = text;
    keywords.forEach(({ word }) => {
      result = result.replace(
        new RegExp(word, "g"),
        `<mark class="bg-yellow-200 cursor-pointer" data-keyword="${word}">${word}</mark>`
      );
    });
    return result;
  };

  return (
    <div
      className="prose max-w-none leading-relaxed"
      dangerouslySetInnerHTML={{ __html: highlightKeywords(body) }}
      onClick={(e) => {
        const target = e.target as HTMLElement;
        if (target.dataset.keyword) {
          navigate(`/keyword/${target.dataset.keyword}`);
        }
      }}
    />
  );
};

export default ArticleBody;
EOF

cat > NewAnce/frontend/src/components/article/Timeline.tsx << 'EOF'
import React from "react";

interface TimelineItem {
  date: string;
  title: string;
  articleId: number;
  isCurrent: boolean;
}

interface Props {
  items: TimelineItem[];
}

const Timeline = ({ items }: Props) => {
  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <h3 className="font-bold text-lg mb-4">사건 흐름 타임라인</h3>
      <p className="text-sm text-gray-400 mb-4">관련 사건의 시간 순서를 파악하여 전체적인 맥락을 이해하세요.</p>
      <div className="relative">
        {items.map((item, idx) => (
          <div key={idx} className="flex gap-4 mb-6">
            <div className="flex flex-col items-center">
              <div className={`w-3 h-3 rounded-full mt-1 ${item.isCurrent ? "bg-blue-500" : "bg-gray-300"}`} />
              {idx < items.length - 1 && <div className="w-0.5 flex-1 bg-gray-200 mt-1" />}
            </div>
            <div>
              <span className="text-sm text-gray-400">{item.date}</span>
              <p className={`font-medium ${item.isCurrent ? "text-blue-600" : "text-gray-800"}`}>
                {item.title}
                {item.isCurrent && <span className="ml-2 text-xs bg-blue-100 text-blue-600 px-2 py-0.5 rounded-full">현재 기사</span>}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Timeline;
EOF

cat > NewAnce/frontend/src/components/article/RelatedArticles.tsx << 'EOF'
import React from "react";
import { useNavigate } from "react-router-dom";

interface Article {
  id: number;
  title: string;
  summary: string;
  press: string;
  perspective: "진보" | "중립" | "보수";
  publishedAt: string;
}

interface Props {
  articles: Article[];
}

const PERSPECTIVE_COLORS = { 진보: "bg-blue-100 text-blue-700", 중립: "bg-gray-100 text-gray-700", 보수: "bg-red-100 text-red-700" };

const RelatedArticles = ({ articles }: Props) => {
  const navigate = useNavigate();

  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <h3 className="font-bold text-lg mb-2">상반된 관점 기사</h3>
      <p className="text-sm text-gray-400 mb-4">관련성이 높으면서도 다른 시각을 제시하는 기사입니다. 여러 관점을 비교하며 균형 잡힌 시각을 키워보세요.</p>
      {articles.map((article) => (
        <div
          key={article.id}
          className="border rounded-lg p-3 mb-3 cursor-pointer hover:bg-gray-50"
          onClick={() => navigate(`/article/${article.id}`)}
        >
          <div className="flex items-center gap-2 mb-1">
            <span className={`text-xs px-2 py-0.5 rounded-full font-medium ${PERSPECTIVE_COLORS[article.perspective]}`}>
              {article.perspective}
            </span>
          </div>
          <p className="font-medium text-sm">{article.title}</p>
          <p className="text-xs text-gray-500 mt-1">{article.summary}</p>
          <div className="flex justify-between mt-2 text-xs text-gray-400">
            <span>{article.press}</span>
            <span>{article.publishedAt}</span>
          </div>
        </div>
      ))}
    </div>
  );
};

export default RelatedArticles;
EOF

cat > NewAnce/frontend/src/components/keyword/PerspectiveBar.tsx << 'EOF'
import React from "react";

interface Props {
  keyword: string;
  distribution: { 진보: number; 중립: number; 보수: number };
  total: number;
}

const PerspectiveBar = ({ keyword, distribution, total }: Props) => {
  const pct = (n: number) => ((n / total) * 100).toFixed(1);

  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <div className="flex items-center gap-2 mb-4">
        <span className="text-gray-400 text-sm">키워드:</span>
        <span className="font-bold text-lg">{keyword}</span>
      </div>
      <h3 className="font-semibold mb-3">관점 분포</h3>
      {(["진보", "중립", "보수"] as const).map((p) => (
        <div key={p} className="mb-3">
          <div className="flex justify-between text-sm mb-1">
            <span>{p}</span>
            <span>{distribution[p]}건 ({pct(distribution[p])}%)</span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className={`h-2 rounded-full ${p === "진보" ? "bg-blue-500" : p === "보수" ? "bg-red-400" : "bg-gray-500"}`}
              style={{ width: `${pct(distribution[p])}%` }}
            />
          </div>
        </div>
      ))}
      <p className="text-xs text-gray-400 mt-3 text-center">이 키워드에 대한 다양한 관점의 기사를 확인하세요</p>
    </div>
  );
};

export default PerspectiveBar;
EOF

cat > NewAnce/frontend/src/pages/HomePage.tsx << 'EOF'
import React from "react";
import HotTopic from "../components/home/HotTopic";
import BiasChart from "../components/home/BiasChart";
import { useUserBias } from "../hooks/useUserBias";

const MOCK_TOPICS = [
  { rank: 1, keyword: "이재명", count: 32456, trend: "up" as const },
  { rank: 2, keyword: "이스라엘 전쟁", count: 28234, trend: "up" as const },
  { rank: 3, keyword: "판사", count: 19678, trend: "up" as const },
  { rank: 4, keyword: "국회 예산안", count: 12456, trend: "same" as const },
  { rank: 5, keyword: "부동산 정책", count: 9876, trend: "down" as const },
];

const HomePage = () => {
  const { biasData, totalCount } = useUserBias();

  return (
    <div className="p-6 grid grid-cols-3 gap-6">
      <div className="col-span-1">
        <HotTopic topics={MOCK_TOPICS} />
      </div>
      <div className="col-span-2">
        <BiasChart data={biasData} totalCount={totalCount} />
      </div>
    </div>
  );
};

export default HomePage;
EOF

cat > NewAnce/frontend/src/pages/ArticlePage.tsx << 'EOF'
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import ArticleBody from "../components/article/ArticleBody";
import Timeline from "../components/article/Timeline";
import RelatedArticles from "../components/article/RelatedArticles";
import BiasChart from "../components/home/BiasChart";
import { useUserBias } from "../hooks/useUserBias";

const ArticlePage = () => {
  const { id } = useParams();
  const { biasData, totalCount } = useUserBias();
  const [article, setArticle] = useState<any>(null);

  useEffect(() => {
    fetch(`/api/articles/${id}`)
      .then((r) => r.json())
      .then(setArticle);
  }, [id]);

  if (!article) return <div className="p-6">로딩 중...</div>;

  return (
    <div className="p-6 max-w-4xl mx-auto">
      {/* 상단 편향 지표 */}
      <div className="mb-4">
        <BiasChart data={biasData} totalCount={totalCount} />
      </div>

      {/* 기사 헤드라인 */}
      <div className="bg-white rounded-lg shadow p-6 mb-4">
        <div className="flex justify-between items-start">
          <h1 className="text-2xl font-bold leading-snug">{article.title}</h1>
          <span className="text-sm px-2 py-1 bg-blue-100 text-blue-700 rounded-full ml-4 shrink-0">{article.perspective}</span>
        </div>
        <p className="text-sm text-gray-400 mt-2">{article.press} · {article.publishedAt}</p>
        <blockquote className="mt-4 p-3 bg-gray-50 border-l-4 border-gray-300 text-gray-600 text-sm">
          {article.summary}
        </blockquote>
      </div>

      {/* 본문 */}
      <div className="bg-white rounded-lg shadow p-6 mb-4">
        <p className="text-xs text-gray-400 mb-3">본문 속 하이라이트된 키워드를 클릭하면 관련 관점을 탐색할 수 있습니다</p>
        <ArticleBody body={article.body} keywords={article.keywords} />
      </div>

      {/* 상반된 관점 기사 + 타임라인 */}
      <div className="grid grid-cols-2 gap-4">
        <RelatedArticles articles={article.relatedArticles} />
        <Timeline items={article.timeline} />
      </div>
    </div>
  );
};

export default ArticlePage;
EOF

cat > NewAnce/frontend/src/pages/KeywordPage.tsx << 'EOF'
import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import PerspectiveBar from "../components/keyword/PerspectiveBar";

const KeywordPage = () => {
  const { keyword } = useParams();
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch(`/api/keywords/${keyword}`)
      .then((r) => r.json())
      .then(setData);
  }, [keyword]);

  if (!data) return <div className="p-6">로딩 중...</div>;

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <PerspectiveBar keyword={keyword!} distribution={data.distribution} total={data.total} />
      <div className="mt-6 space-y-3">
        {data.articles.map((article: any) => (
          <div key={article.id} className="bg-white rounded-lg shadow p-4">
            <p className="font-medium">{article.title}</p>
            <p className="text-sm text-gray-500 mt-1">{article.summary}</p>
            <div className="flex justify-between text-xs text-gray-400 mt-2">
              <span>{article.press}</span>
              <span>{article.publishedAt}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default KeywordPage;
EOF

cat > NewAnce/frontend/src/hooks/useUserBias.ts << 'EOF'
import { useEffect, useState } from "react";

interface BiasData {
  name: string;
  value: number;
}

export const useUserBias = () => {
  const [biasData, setBiasData] = useState<BiasData[]>([
    { name: "진보", value: 0 },
    { name: "중립", value: 0 },
    { name: "보수", value: 0 },
  ]);
  const [totalCount, setTotalCount] = useState(0);

  useEffect(() => {
    fetch("/api/bias/me")
      .then((r) => r.json())
      .then((data) => {
        setBiasData([
          { name: "진보", value: data.counts["진보"] },
          { name: "중립", value: data.counts["중립"] },
          { name: "보수", value: data.counts["보수"] },
        ]);
        setTotalCount(data.total);
      });
  }, []);

  return { biasData, totalCount };
};
EOF

cat > NewAnce/frontend/src/hooks/useKeyword.ts << 'EOF'
import { useState } from "react";
import { useNavigate } from "react-router-dom";

export const useKeyword = () => {
  const [query, setQuery] = useState("");
  const navigate = useNavigate();

  const search = () => {
    if (query.trim()) navigate(`/keyword/${query.trim()}`);
  };

  return { query, setQuery, search };
};
EOF

cat > NewAnce/frontend/src/store/biasStore.ts << 'EOF'
import { create } from "zustand";

interface BiasState {
  counts: { 진보: number; 중립: number; 보수: number };
  total: number;
  addArticle: (perspective: "진보" | "중립" | "보수") => void;
}

export const useBiasStore = create<BiasState>((set) => ({
  counts: { 진보: 0, 중립: 0, 보수: 0 },
  total: 0,
  addArticle: (perspective) =>
    set((state) => ({
      counts: { ...state.counts, [perspective]: state.counts[perspective] + 1 },
      total: state.total + 1,
    })),
}));
EOF

# ─────────────────────────────────────────
# BACKEND
# ─────────────────────────────────────────

cat > NewAnce/backend/main.py << 'EOF'
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
EOF

cat > NewAnce/backend/api/articles.py << 'EOF'
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
EOF

cat > NewAnce/backend/api/keywords.py << 'EOF'
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
EOF

cat > NewAnce/backend/api/bias.py << 'EOF'
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
EOF

cat > NewAnce/backend/api/question.py << 'EOF'
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
EOF

cat > NewAnce/backend/crawler/naver_news.py << 'EOF'
import requests
from bs4 import BeautifulSoup

MEDIA_BIAS = {
    "조선일보": "보수", "중앙일보": "보수", "동아일보": "보수",
    "한겨레": "진보", "경향신문": "진보", "한국일보": "진보",
    "연합뉴스": "중립", "KBS": "중립", "MBC": "중립"
}

def crawl_naver_news() -> list[dict]:
    url = "https://news.naver.com/section/100"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    articles = []
    for item in soup.select(".sa_text"):
        try:
            title = item.select_one(".sa_text_title").get_text(strip=True)
            summary = item.select_one(".sa_text_lede").get_text(strip=True)
            press = item.select_one(".sa_text_press").get_text(strip=True)
            link = item.select_one("a")["href"]
            articles.append({
                "title": title,
                "summary": summary,
                "press": press,
                "link": link,
                "media_bias": MEDIA_BIAS.get(press)
            })
        except Exception:
            continue
    return articles
EOF

cat > NewAnce/backend/crawler/scheduler.py << 'EOF'
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
EOF

cat > NewAnce/backend/pipeline/classifier.py << 'EOF'
from openai import OpenAI
import json

client = OpenAI()

SYSTEM_PROMPT = """
당신은 뉴스 기사의 정치적 관점을 분류하는 전문가입니다.
기사를 분석하여 다음 중 하나로 분류하세요: 진보 / 중립 / 보수
반드시 JSON 형식으로만 응답하세요.
{"perspective": "진보" | "중립" | "보수", "confidence": 0.0~1.0}
"""

def classify_perspective(title: str, body: str, media_bias: str | None = None) -> dict:
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"제목: {title}\n본문: {body[:500]}"}
        ],
        response_format={"type": "json_object"}
    )
    result = json.loads(response.choices[0].message.content)
    if media_bias and result["perspective"] == media_bias:
        result["confidence"] = min(result["confidence"] + 0.1, 1.0)
    return result
EOF

cat > NewAnce/backend/pipeline/keyword_extractor.py << 'EOF'
from openai import OpenAI
import json

client = OpenAI()

def extract_keywords(title: str, body: str) -> dict:
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": """
기사에서 키워드를 추출하여 JSON으로 반환하세요.
{"persons": [], "places": [], "topics": []}
각 항목은 최대 5개까지만 추출합니다.
            """},
            {"role": "user", "content": f"제목: {title}\n본문: {body[:800]}"}
        ],
        response_format={"type": "json_object"}
    )
    return json.loads(response.choices[0].message.content)
EOF

cat > NewAnce/backend/pipeline/summarizer.py << 'EOF'
from openai import OpenAI

client = OpenAI()

def summarize_article(title: str, body: str) -> str:
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "다음 뉴스 기사를 한 문장으로 요약하세요. 핵심 사실만 담아 간결하게 작성하세요."},
            {"role": "user", "content": f"제목: {title}\n본문: {body[:800]}"}
        ]
    )
    return response.choices[0].message.content
EOF

cat > NewAnce/backend/pipeline/question_generator.py << 'EOF'
from openai import OpenAI

client = OpenAI()

def calculate_bias_score(user_history: list[dict]) -> dict:
    total = len(user_history)
    if total == 0:
        return {"score": 0, "dominant": None}
    counts = {"진보": 0, "중립": 0, "보수": 0}
    for article in user_history:
        counts[article["perspective"]] += 1
    dominant = max(counts, key=counts.get)
    score = counts[dominant] / total
    return {"score": score, "dominant": dominant, "counts": counts}

def generate_question(user_history: list[dict], top_keyword: str) -> str | None:
    bias = calculate_bias_score(user_history)
    if len(user_history) <= 5 or bias["score"] < 0.6:
        return None
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": """
사용자가 편향된 뉴스만 소비하고 있음을 부드럽게 알려주는
비판적 사고 유도 질문을 한 문장으로 생성하세요.
직접적인 비난 없이 반대 관점을 자연스럽게 환기시켜야 합니다.
            """},
            {"role": "user", "content": f"주요 키워드: {top_keyword}, 소비 성향: {bias['dominant']}"}
        ]
    )
    return response.choices[0].message.content
EOF

cat > NewAnce/backend/models/article.py << 'EOF'
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
EOF

cat > NewAnce/backend/models/keyword.py << 'EOF'
from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from db.database import Base

class Keyword(Base):
    __tablename__ = "keywords"

    id = Column(Integer, primary_key=True, index=True)
    word = Column(String(100), unique=True, nullable=False)
    click_count = Column(Integer, default=0)
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())
EOF

cat > NewAnce/backend/models/user.py << 'EOF'
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
EOF

cat > NewAnce/backend/db/database.py << 'EOF'
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:password@localhost:5432/newance")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
EOF

cat > NewAnce/backend/db/redis_client.py << 'EOF'
import redis
import os

redis_client = redis.Redis(
    host=os.getenv("REDIS_HOST", "localhost"),
    port=int(os.getenv("REDIS_PORT", 6379)),
    decode_responses=True
)

def get_cache(key: str):
    return redis_client.get(key)

def set_cache(key: str, value: str, ttl: int = 300):
    redis_client.setex(key, ttl, value)
EOF

cat > NewAnce/docker-compose.yml << 'EOF'
version: "3.8"

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/newance
      - REDIS_HOST=redis
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: newance
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  pgdata:
EOF

echo "✅ NewAnce 더미 파일 생성 완료!"