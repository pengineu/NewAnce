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
