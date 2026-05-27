from openai import OpenAI
import os
import json

def get_client():
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        return None
    return OpenAI(api_key=api_key)

def extract_keywords(title: str, body: str) -> dict:
    client = get_client()
    if not client:
        # API 키 없을 때 Mock 키워드 반환
        return {"persons": [], "places": [], "topics": []}

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