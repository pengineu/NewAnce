import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import PerspectiveBar from "../components/keyword/PerspectiveBar";

const KeywordPage = () => {
  const { keyword } = useParams();
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    fetch(`/api/keywords/${keyword}`)
      .then((r) => r.json())
      .then(setData);
  }, [keyword]);

  if (!data) return <div className="p-6">로딩 중...</div>;

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <PerspectiveBar keyword={keyword!} distribution={data.distribution} total={data.total} />
      <div className="mt-6 space-y-3">
        {data.articles.map((article: any) => (
          <div key={article.id} className="bg-white rounded-lg shadow p-4">
            <p className="font-medium">{article.title}</p>
            <p className="text-sm text-gray-500 mt-1">{article.summary}</p>
            <div className="flex justify-between text-xs text-gray-400 mt-2">
              <span>{article.press}</span>
              <span>{article.publishedAt}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default KeywordPage;
