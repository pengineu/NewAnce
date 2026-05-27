from openai import OpenAI
import os

def get_client():
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        return None
    return OpenAI(api_key=api_key)

def summarize_article(title: str, body: str) -> str:
    client = get_client()
    if not client:
        # API 키 없을 때 제목을 요약으로 반환
        return title[:100]

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "다음 뉴스 기사를 한 문장으로 요약하세요. 핵심 사실만 담아 간결하게 작성하세요."},
            {"role": "user", "content": f"제목: {title}\n본문: {body[:800]}"}
        ]
    )
    return response.choices[0].message.content