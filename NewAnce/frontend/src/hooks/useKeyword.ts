import { useState } from "react";
import { useNavigate } from "react-router-dom";

export const useKeyword = () => {
  const [query, setQuery] = useState("");
  const navigate = useNavigate();

  const search = () => {
    if (query.trim()) navigate(`/keyword/${query.trim()}`);
  };

  return { query, setQuery, search };
};
