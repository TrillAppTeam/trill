import { Outlet } from "react-router-dom";
import Navbar from "./components/Navbar";

function App() {
  return (
    <div className="bg-purple h-screen">
      <Navbar />
      <Outlet />
    </div>
  );
}

export default App;