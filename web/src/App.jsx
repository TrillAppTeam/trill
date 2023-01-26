import { Outlet } from "react-router-dom";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";

function App() {
  return (
    <div className="bg-trillPurple min-h-screen flex flex-col">
      <Navbar />

      {/* Page Content */}
      <div className="flex-grow">
        <Outlet />
      </div>

      <Footer />
    </div>
  );
}

export default App;