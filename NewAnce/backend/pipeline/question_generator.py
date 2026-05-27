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
