import React from "react";
import { useNavigate } from "react-router-dom";

interface Props {
  body: string;
  keywords: { word: string; type: string }[];
}

const ArticleBody = ({ body, keywords }: Props) => {
  const navigate = useNavigate();

  const highlightKeywords = (text: string) => {
    let result = text;
    keywords.forEach(({ word }) => {
      result = result.replace(
        new RegExp(word, "g"),
        `<mark class="bg-yellow-200 cursor-pointer" data-keyword="${word}">${word}</mark>`
      );
    });
    return result;
  };

  return (
    <div
      className="prose max-w-none leading-relaxed"
      dangerouslySetInnerHTML={{ __html: highlightKeywords(body) }}
      onClick={(e) => {
        const target = e.target as HTMLElement;
        if (target.dataset.keyword) {
          navigate(`/keyword/${target.dataset.keyword}`);
        }
      }}
    />
  );
};

export default ArticleBody;
