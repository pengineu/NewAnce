from openai import OpenAI
import os
import json
import random

def get_client():
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        return None
    return OpenAI(api_key=api_key)

SYSTEM_PROMPT = """
당신은 뉴스 기사의 정치적 관점을 분류하는 전문가입니다.
기사를 분석하여 다음 중 하나로 분류하세요: 진보 / 중립 / 보수
반드시 JSON 형식으로만 응답하세요.
{"perspective": "진보" | "중립" | "보수", "confidence": 0.0~1.0}
"""

def classify_perspective(title: str, body: str, media_bias: str | None = None) -> dict:
    client = get_client()
    if not client:
        # API 키 없을 때 언론사 출처 기반으로 분류
        if media_bias:
            return {"perspective": media_bias, "confidence": 0.7}
        return {"perspective": random.choice(["진보", "중립", "보수"]), "confidence": 0.5}

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