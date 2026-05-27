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
