import React from "react";

interface Topic {
  rank: number;
  keyword: string;
  count: number;
  trend: "up" | "down" | "same";
}

interface Props {
  topics: Topic[];
}

const HotTopic = ({ topics }: Props) => {
  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <h2 className="font-bold text-lg mb-3">실시간 국내 Hot Topic</h2>
      {topics.map((topic) => (
        <div key={topic.rank} className="flex items-center py-2 border-b last:border-none">
          <span className="w-6 text-gray-500 font-bold">{topic.rank}</span>
          <span className="flex-1 font-medium">{topic.keyword}</span>
          <span className="text-sm text-gray-400">{topic.count.toLocaleString()}건</span>
        </div>
      ))}
    </div>
  );
};

export default HotTopic;
