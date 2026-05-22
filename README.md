# 뉴앙스 (NewAnce)
> 비판적인 시각을 갖도록 돕는 정치·정책 뉴스 플랫폼

<br>

## 📌 프로젝트 소개

뉴앙스(NewAnce)는 필터 버블과 에코 챔버 현상으로 인해 편향된 뉴스 소비를 반복하는 사용자들이 **스스로 자신의 편향을 인식하고, 다양한 관점의 기사를 자발적으로 탐색할 수 있도록 돕는 뉴스 플랫폼**입니다.

<br>

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| Frontend | React, TypeScript, TailwindCSS |
| Backend | Python, FastAPI |
| Database | PostgreSQL, Redis |
| AI/ML | OpenAI GPT-4o, LangChain |
| Crawling | BeautifulSoup4, Selenium |
| Infra | Docker, GitHub Actions |

<br>

## 📁 프로젝트 구조

```
NewAnce/
├── frontend/
│   ├── public/
│   └── src/
│       ├── components/
│       │   ├── common/          # Header, SearchBar 등 공통 컴포넌트
│       │   ├── home/            # 홈화면 (HotTopic, BiasChart)
│       │   ├── article/         # 기사 페이지 (ArticleBody, Timeline, RelatedArticles)
│       │   └── keyword/         # 키워드 페이지 (PerspectiveBar)
│       ├── pages/
│       │   ├── HomePage.tsx
│       │   ├── ArticlePage.tsx
│       │   └── KeywordPage.tsx
│       ├── hooks/               # useUserBias, useKeyword 등 커스텀 훅
│       └── store/               # 전역 상태 (Zustand)
│
├── backend/
│   ├── main.py
│   ├── api/
│   │   ├── articles.py          # 기사 조회 API
│   │   ├── keywords.py          # 키워드 관련 API
│   │   ├── bias.py              # 편향 지표 API
│   │   └── question.py          # 경각심 질문 생성 API
│   ├── crawler/
│   │   ├── naver_news.py        # 네이버 뉴스 크롤러
│   │   └── scheduler.py         # 크롤링 스케줄러 (APScheduler)
│   ├── pipeline/
│   │   ├── classifier.py        # LLM 기반 관점 분류
│   │   ├── keyword_extractor.py # LLM 기반 키워드 추출
│   │   ├── summarizer.py        # 한 줄 요약 생성
│   │   └── question_generator.py # 경각심 질문 생성
│   ├── models/
│   │   ├── article.py
│   │   ├── keyword.py
│   │   └── user.py
│   └── db/
│       ├── database.py          # DB 연결 설정
│       └── redis_client.py      # Redis 캐시 설정
│
└── docker-compose.yml
```

<br>

## ⚙️ 핵심 알고리즘

### 1. 네이버 뉴스 크롤링
네이버 뉴스에서 정치·정책 카테고리 기사를 주기적으로 수집합니다.

```python
# crawler/naver_news.py
import requests
from bs4 import BeautifulSoup

MEDIA_BIAS = {
    "조선일보": "보수", "중앙일보": "보수", "동아일보": "보수",
    "한겨레": "진보", "경향신문": "진보", "한국일보": "진보",
    "연합뉴스": "중립", "KBS": "중립", "MBC": "중립"
}

def crawl_naver_news(category: str = "politics") -> list[dict]:
    url = f"https://news.naver.com/section/100"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, "html.parser")

    articles = []
    for item in soup.select(".sa_text"):
        title = item.select_one(".sa_text_title").get_text(strip=True)
        summary = item.select_one(".sa_text_lede").get_text(strip=True)
        press = item.select_one(".sa_text_press").get_text(strip=True)
        link = item.select_one("a")["href"]

        articles.append({
            "title": title,
            "summary": summary,
            "press": press,
            "link": link,
            "media_bias": MEDIA_BIAS.get(press, None)
        })
    return articles
```

<br>

### 2. LLM 기반 관점 분류 파이프라인
수집된 기사의 정치적 성향을 LLM으로 분류하고, 언론사 출처를 보조 지표로 활용합니다.

```python
# pipeline/classifier.py
from openai import OpenAI

client = OpenAI()

SYSTEM_PROMPT = """
당신은 뉴스 기사의 정치적 관점을 분류하는 전문가입니다.
기사를 분석하여 다음 중 하나로 분류하세요: 진보 / 중립 / 보수
반드시 JSON 형식으로만 응답하세요.
{"perspective": "진보" | "중립" | "보수", "confidence": 0.0~1.0}
"""

def classify_perspective(title: str, body: str, media_bias: str | None) -> dict:
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": f"제목: {title}\n본문: {body[:500]}"}
        ],
        response_format={"type": "json_object"}
    )
    result = response.choices[0].message.content

    # 언론사 출처를 보조 지표로 신뢰도 보정
    if media_bias and result["perspective"] == media_bias:
        result["confidence"] = min(result["confidence"] + 0.1, 1.0)

    return result
```

<br>

### 3. 키워드 추출
기사 본문에서 인물·장소·법안·연관 토픽 키워드를 추출합니다.

```python
# pipeline/keyword_extractor.py
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
    return response.choices[0].message.content
```

<br>

### 4. 편향 감지 및 경각심 질문 생성
사용자의 기사 열람 이력을 분석하여 편향도가 임계치(60%)를 초과할 경우 경각심 유발 질문을 생성합니다.

```python
# pipeline/question_generator.py
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

    # 기사 5개 초과 & 편향도 60% 이상일 때만 질문 생성
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
```

<br>

### 5. 상반된 관점 기사 추천
현재 기사와 관련성이 높으면서 반대 성향의 기사를 추천합니다.

```python
# api/articles.py
def get_opposite_articles(article_id: int, db: Session) -> list[Article]:
    current = db.query(Article).filter(Article.id == article_id).first()
    opposite = "보수" if current.perspective == "진보" else "진보"

    # 공유 키워드 수 기준으로 정렬
    candidates = db.query(Article).filter(
        Article.perspective == opposite
    ).all()

    scored = []
    for candidate in candidates:
        shared = len(set(current.keywords) & set(candidate.keywords))
        if shared > 0:
            scored.append((candidate, shared))

    scored.sort(key=lambda x: x[1], reverse=True)
    return [article for article, _ in scored[:5]]
```

<br>

## 🚀 실행 방법

```bash
# 저장소 클론
git clone https://github.com/Codingfetus/NewAnce.git
cd NewAnce

# Docker로 전체 실행
docker-compose up --build

# 또는 개별 실행
# 백엔드
cd backend
pip install -r requirements.txt
uvicorn main:app --reload

# 프론트엔드
cd frontend
npm install
npm run dev
```

<br>

## 📄 라이선스

MIT License © 2026 뉴스앙
