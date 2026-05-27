import React from "react";
import { PieChart, Pie, Cell, Legend } from "recharts";

interface Props {
  data: { name: string; value: number }[];
  totalCount: number;
}

const COLORS = { 진보: "#4A90D9", 중립: "#9B9B9B", 보수: "#E05C5C" };

const BiasChart = ({ data, totalCount }: Props) => {
  if (totalCount < 5) {
    return (
      <div className="flex flex-col items-center justify-center h-48 text-gray-400">
        <p className="text-lg font-medium">아직 읽은 기사가 없습니다</p>
        <p className="text-sm">기사를 클릭하여 읽기 시작하면 관점 분포가 표시됩니다</p>
      </div>
    );
  }

  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <div className="flex justify-between items-center mb-2">
        <h2 className="font-bold text-lg">내가 본 기사 관점 분포</h2>
        <span className="text-sm text-gray-500">읽은 기사: {totalCount}개</span>
      </div>
      <PieChart width={300} height={200}>
        <Pie data={data} cx={100} cy={100} outerRadius={80} dataKey="value">
          {data.map((entry) => (
            <Cell key={entry.name} fill={COLORS[entry.name as keyof typeof COLORS]} />
          ))}
        </Pie>
        <Legend />
      </PieChart>
    </div>
  );
};

export default BiasChart;
