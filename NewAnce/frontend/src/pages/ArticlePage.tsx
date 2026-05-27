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
