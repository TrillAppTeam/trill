import React, { useEffect } from 'react';
import { Outlet } from "react-router-dom";
import Navbar from "../components/Navbar";
import Footer from "../components/Footer";
import { QueryClient, QueryClientProvider, useQuery} from "@tanstack/react-query";

const queryClient = new QueryClient();

import axios from 'axios';

function Home() {
    useEffect (() => {
        let token;
        try {
            token = (window.location.href).split('=')[1];
            console.log(token);
            // let result = useQuery({
            //     queryKey: ['auth'], 
            //     queryFn: axios({
            //         method: 'post',
            //         url: 'https://trill.auth.us-east-1.amazoncognito.com/oauth2/token',
            //         headers: {
            //             'Content-Type': 'application/x-www-form-urlencoded'
            //         }, 
            //         data: {
            //           grant_type: 'authorization_code',
            //           client_id: '126gi8rqrvn4rbv1kt7ef714oa',
            //           code: token,
            //           redirect_uri: 'https://www.trytrill.com/home',
            //         }
            // })})
            let result = axios({
                        method: 'post',
                        url: 'https://trill.auth.us-east-1.amazoncognito.com/oauth2/token',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        }, 
                        data: {
                          grant_type: 'authorization_code',
                          client_id: '126gi8rqrvn4rbv1kt7ef714oa',
                          code: token,
                          redirect_uri: 'https://www.trytrill.com/home',
                        }
                }).then((res) => res.data);
            console.group(result);
        } catch (e) {
            console.log(e.toString());
            return;
        }
    }, []);

    return (
        <QueryClientProvider client={queryClient}>
            <div className="bg-trillPurple min-h-screen flex flex-col">
                <Navbar />

                {/* Page Content */}
                <div className="flex-grow">
                    <Outlet />
                </div>
                <Footer />
            </div>  
        </QueryClientProvider>
    );
}

export default Home;