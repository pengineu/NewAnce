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
