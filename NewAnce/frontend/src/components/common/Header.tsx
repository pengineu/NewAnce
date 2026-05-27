import React from "react";
import SearchBar from "./SearchBar";

const Header = () => {
  return (
    <header className="flex items-center px-6 py-3 bg-gray-900 text-white">
      <h1 className="text-xl font-bold mr-4 cursor-pointer">뉴앙스</h1>
      <SearchBar />
    </header>
  );
};

export default Header;
