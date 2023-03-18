import { Outlet, useNavigate } from "react-router-dom";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
import Loading from "../components/Loading";
import { useQuery } from "@tanstack/react-query";
import axios from 'axios';

function Home() {
    const navigate = useNavigate();
    const { isLoading } = useQuery(['fetchToken'], () => 
        axios({
            method: 'post',
            url: 'https://trill.auth.us-east-1.amazoncognito.com/oauth2/token',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }, 
            data: {
                grant_type: 'authorization_code',
                client_id: '126gi8rqrvn4rbv1kt7ef714oa',
                code: (window.location.href).split('=')[1],
                redirect_uri: 'https://www.trytrill.com/home',
            }}).then((res) => {
                sessionStorage.setItem('access_token', res.data.access_token);
                return res;
            }).catch((error) => {navigate("/"); return error;}),
        { enabled: !sessionStorage.getItem('access_token'), refetchOnWindowFocus: false});

    return (
        <div className="bg-trillPurple min-h-screen flex flex-col">
            {isLoading && !sessionStorage.getItem('access_token') ? <Loading/> : <>
                <Navbar />
                {/* Page Content */}
                <div className="flex-grow">
                    <Outlet />
                </div>
                <Footer />
            </>}
        </div>  
    );
}

export default Home;