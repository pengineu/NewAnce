import React from "react";

interface TimelineItem {
  date: string;
  title: string;
  articleId: number;
  isCurrent: boolean;
}

interface Props {
  items: TimelineItem[];
}

const Timeline = ({ items }: Props) => {
  return (
    <div className="p-4 bg-white rounded-lg shadow">
      <h3 className="font-bold text-lg mb-4">사건 흐름 타임라인</h3>
      <p className="text-sm text-gray-400 mb-4">관련 사건의 시간 순서를 파악하여 전체적인 맥락을 이해하세요.</p>
      <div className="relative">
        {items.map((item, idx) => (
          <div key={idx} className="flex gap-4 mb-6">
            <div className="flex flex-col items-center">
              <div className={`w-3 h-3 rounded-full mt-1 ${item.isCurrent ? "bg-blue-500" : "bg-gray-300"}`} />
              {idx < items.length - 1 && <div className="w-0.5 flex-1 bg-gray-200 mt-1" />}
            </div>
            <div>
              <span className="text-sm text-gray-400">{item.date}</span>
              <p className={`font-medium ${item.isCurrent ? "text-blue-600" : "text-gray-800"}`}>
                {item.title}
                {item.isCurrent && <span className="ml-2 text-xs bg-blue-100 text-blue-600 px-2 py-0.5 rounded-full">현재 기사</span>}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Timeline;
