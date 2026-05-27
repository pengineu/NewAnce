import React from "react";
import HotTopic from "../components/home/HotTopic";
import BiasChart from "../components/home/BiasChart";
import { useUserBias } from "../hooks/useUserBias";

const MOCK_TOPICS = [
  { rank: 1, keyword: "이재명", count: 32456, trend: "up" as const },
  { rank: 2, keyword: "이스라엘 전쟁", count: 28234, trend: "up" as const },
  { rank: 3, keyword: "판사", count: 19678, trend: "up" as const },
  { rank: 4, keyword: "국회 예산안", count: 12456, trend: "same" as const },
  { rank: 5, keyword: "부동산 정책", count: 9876, trend: "down" as const },
];

const HomePage = () => {
  const { biasData, totalCount } = useUserBias();

  return (
    <div className="p-6 grid grid-cols-3 gap-6">
      <div className="col-span-1">
        <HotTopic topics={MOCK_TOPICS} />
      </div>
      <div className="col-span-2">
        <BiasChart data={biasData} totalCount={totalCount} />
      </div>
    </div>
  );
};

export default HomePage;
