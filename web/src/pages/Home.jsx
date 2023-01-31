import React, { useEffect } from 'react';
import { Outlet } from "react-router-dom";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";

function Home() {
    useEffect (() => {
        let token;
        try {
            token = (window.location.href).split('=')[1];
        } catch {
            console.log("Error: No auth token found.");
        } finally {
            console.log(token);
            //api call
        };
    }, []);

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

export default Home;