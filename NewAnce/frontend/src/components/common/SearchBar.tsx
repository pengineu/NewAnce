import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

const SearchBar = () => {
  const [query, setQuery] = useState("");
  const navigate = useNavigate();

  const handleSearch = (e: React.KeyboardEvent) => {
    if (e.key === "Enter" && query.trim()) {
      navigate(`/keyword/${query.trim()}`);
    }
  };

  return (
    <input
      type="text"
      placeholder="키워드로 다양한 관점 찾기"
      value={query}
      onChange={(e) => setQuery(e.target.value)}
      onKeyDown={handleSearch}
      className="w-full px-4 py-2 rounded-full bg-white text-gray-800 outline-none"
    />
  );
};

export default SearchBar;
