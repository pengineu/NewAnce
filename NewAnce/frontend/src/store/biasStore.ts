import { create } from "zustand";

interface BiasState {
  counts: { 진보: number; 중립: number; 보수: number };
  total: number;
  addArticle: (perspective: "진보" | "중립" | "보수") => void;
}

export const useBiasStore = create<BiasState>((set) => ({
  counts: { 진보: 0, 중립: 0, 보수: 0 },
  total: 0,
  addArticle: (perspective) =>
    set((state) => ({
      counts: { ...state.counts, [perspective]: state.counts[perspective] + 1 },
      total: state.total + 1,
    })),
}));
