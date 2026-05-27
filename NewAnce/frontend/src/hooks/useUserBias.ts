import { useEffect, useState } from "react";

interface BiasData {
  name: string;
  value: number;
}

export const useUserBias = () => {
  const [biasData, setBiasData] = useState<BiasData[]>([
    { name: "진보", value: 0 },
    { name: "중립", value: 0 },
    { name: "보수", value: 0 },
  ]);
  const [totalCount, setTotalCount] = useState(0);

  useEffect(() => {
    fetch("/api/bias/me")
      .then((r) => r.json())
      .then((data) => {
        setBiasData([
          { name: "진보", value: data.counts["진보"] },
          { name: "중립", value: data.counts["중립"] },
          { name: "보수", value: data.counts["보수"] },
        ]);
        setTotalCount(data.total);
      });
  }, []);

  return { biasData, totalCount };
};
