import React, { useEffect, useState } from 'react';
 
import Titles from "../components/Titles"

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
        <div className="max-w-4xl mx-auto">
            {/* Profile Section */}
            <div className="flex flex-row py-10 justify-between">
        
                <div className="flex flex-row">
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
                            <button className="btn btn-xs bg-gray-700 hover:bg-trillBlue hover:text-black mt-2">Edit Profile</button>
                        </div>
                        <h2 className="text-xl pt-2">{user.bio}</h2>
                    </div>
                </div>
              
                {/* User Statistics */}
                <div className="stats stats-horizontal justify-self-end">
                    <div className="stat bg-gray-700">
                        <div className="stat-title text-white">Albums Rated</div>
                        <div className="stat-value text-trillBlue">310</div>
                    </div>
                    
                    <div className="stat bg-gray-700">
                        <div className="stat-title text-white">Followers</div>
                        <div className="stat-value text-trillBlue">98</div>
                    </div>
                    
                    <div className="stat bg-gray-700">
                        <div className="stat-title text-white">Following</div>
                        <div className="stat-value text-trillBlue">278</div>
                    </div>
                </div>
            </div>

            <Titles title="Favorite Albums"/>
        </div>
    );
}

export default Profile;