import React from "react";

interface Props {
  keyword: string;
  distribution: { 진보: number; 중립: number; 보수: number };
  total: number;
}

const PerspectiveBar = ({ keyword, distribution, total }: Props) => {
  const pct = (n: number) => ((n / total) * 100).toFixed(1);

  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <div className="flex items-center gap-2 mb-4">
        <span className="text-gray-400 text-sm">키워드:</span>
        <span className="font-bold text-lg">{keyword}</span>
      </div>
      <h3 className="font-semibold mb-3">관점 분포</h3>
      {(["진보", "중립", "보수"] as const).map((p) => (
        <div key={p} className="mb-3">
          <div className="flex justify-between text-sm mb-1">
            <span>{p}</span>
            <span>{distribution[p]}건 ({pct(distribution[p])}%)</span>
          </div>
          <div className="w-full bg-gray-200 rounded-full h-2">
            <div
              className={`h-2 rounded-full ${p === "진보" ? "bg-blue-500" : p === "보수" ? "bg-red-400" : "bg-gray-500"}`}
              style={{ width: `${pct(distribution[p])}%` }}
            />
          </div>
        </div>
      ))}
      <p className="text-xs text-gray-400 mt-3 text-center">이 키워드에 대한 다양한 관점의 기사를 확인하세요</p>
    </div>
  );
};

export default PerspectiveBar;
