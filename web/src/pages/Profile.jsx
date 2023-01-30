import React, { useEffect, useState } from 'react';
import { Link } from "react-router-dom";
 
// Components
import Titles from "../components/Titles"
import AvgReviews from "../components/AvgReviews"
import UserStats from "../components/UserStats"

function Profile() {
    const [user, setUser] = useState({});
    
    useEffect (() => {
        // Api call and gets user data
        let userData = {
            firstName: "Ashley",
            bio: "I like creed and taylor swift",
            followers: 9,
            following: 10,
            favs: [{}],
            reviews: [{}],
            profilePic: null
        };

        setUser(userData);
    }, []);

    return (
        <div className="max-w-5xl mx-auto">
            {/* Profile Section */}
            <div className="flex flex-row flex-wrap py-10 justify-between mx-10">
                <div className="flex flex-row m-5">
                    {/* Profile Picture */}
                    <div className="avatar placeholder">
                        <div className="bg-neutral-focus text-neutral-content rounded-full w-24 ring-2 ring-trillBlue">
                            {user.profilePic ? 
                                <span className="text-2xl text-white">{user.firstName ? user.firstName[0]: ""}</span>
                                :
                                <img src="https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg" />}      
                        </div>
                    </div> 
                    
                    {/* Name and Bio */}
                    <div className="pl-10">
                        <div className="flex gap-2">
                            <h1 className="font-bold text-white text-3xl">{user.firstName}</h1>
                            <Link to="/User/Settings">
                                <button className="btn btn-xs bg-gray-700 hover:bg-trillBlue hover:text-black mt-2">Edit Profile</button>
                            </Link>
                        </div>
                        <h2 className="text-xl pt-2">{user.bio}</h2>
                    </div>
                </div>
              
                {/* User Statistics */}
                <div className="pt-5">
                    <UserStats />
                </div>
                
            </div>
            

            <div className="flex flex-row justify-between flex-wrap pl-10 pr-10">
                <div className="w-2/3 pt-5">
                    <Titles title="Favorite Albums"/>
                    <Titles title="Recent Reviews"/>
                    <Titles title="Popular Reviews"/>
                    <Titles title="Following"/>
                </div>
                <div>
                    <AvgReviews />
                </div>
            </div>
        </div>
    );
}

export default Profile;