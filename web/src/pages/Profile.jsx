import React, { useEffect, useState } from 'react';
import { Link } from "react-router-dom";
 
// Components
import Titles from "../components/Titles"
import AvgReviews from "../components/AvgReviews"
import UserStats from "../components/UserStats"
import Album from "../components/Album"
import Avatar from "../components/Avatar"

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
            profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg"
        };

        setUser(userData);
    }, []);

    const userAvatar = {
        firstName: user.firstName,
        profilePic: user.profilePic,
        size: "24"
    }

    const followingAvatars = {
        firstName: user.firstName,
        profilePic: "https://i.kym-cdn.com/photos/images/newsfeed/001/584/795/a28.png",
        size: "10"
    }

    const followingDummy = [];
    for (let i = 0; i < 35; i++) {
        followingDummy.push(<Avatar user={ followingAvatars } />);
    }

    return (
        <div className="max-w-5xl mx-auto">
            {/* Profile Section */}
            <div className="flex flex-row flex-wrap py-10 justify-between mx-10">
                <div className="flex flex-row m-5">
                    {/* Profile Picture */}
                    <Avatar user={ userAvatar } />

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
                        <div className="text-white flex flex-row justify-center gap-5 pb-[50px]">
                            <Album album = {{ img: "/blondAlbum.jpg", size: "200"}} />
                            <Album album = {{ img: "/allThingsMustPassAlbum.jpg", size: "200"}} />
                            <Album album = {{ img: "/currentsAlbum.jpg", size: "200"}} />
                            <Album album = {{ img: "/whereTheLightIsAlbum.jpg", size: "200"}} />
                        </div>

                    <Titles title="Recent Reviews"/>
                    <Titles title="Popular Reviews"/>

                    <Titles title="Following"/>
                    <div class="flex flex-col justify-center items-left max-w-6xl pb-10">
                        <div class="flex gap-2 flex-wrap">
                            {followingDummy}                         
                        </div>
                    </div>

                    <Titles title="Followers"/>
                    <div class="flex flex-col justify-center items-left max-w-6xl">
                        <div class="flex gap-2 flex-wrap">
                            {followingDummy}                         
                        </div>
                    </div>

                </div>

                <div>
                    <AvgReviews />
                </div>

            </div>
        </div>
    );
}

export default Profile;