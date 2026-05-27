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
