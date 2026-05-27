import { BrowserRouter, Routes, Route } from "react-router-dom";
import Header from "./components/common/Header";
import HomePage from "./pages/HomePage";
import ArticlePage from "./pages/ArticlePage";
import KeywordPage from "./pages/KeywordPage";

function App() {
  return (
    <BrowserRouter>
      <Header />
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="/article/:id" element={<ArticlePage />} />
        <Route path="/keyword/:keyword" element={<KeywordPage />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;