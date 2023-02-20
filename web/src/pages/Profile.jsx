import React, { useEffect, useState } from 'react';
import { Link } from "react-router-dom";
 
// Components
import Titles from "../components/Titles"
import AvgReviews from "../components/AvgReviews"
import UserStats from "../components/UserStats"
import Album from "../components/Album"
import Avatar from "../components/Avatar"
import Review from "../components/Review"

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
        profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
        size: "11"
    }

    const followingDummy = [];
    for (let i = 0; i < 30; i++) {
        followingDummy.push(<Avatar user={ followingAvatars } />);
    }

    let reviewDummy = {
        user: "Ligma Johnson",
        profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
        review: "For Kevin Parker, perfectionism is a lonely thing.",
        rating: 5,
        albumImg: "https://upload.wikimedia.org/wikipedia/en/9/9b/Tame_Impala_-_Currents.png",
        albumName: "Currents",
        albumYear: "2020",
        artist: "Tame Impala"
    }

    let anotherExample = {
        user: "Jake Gyllenhal",
        profilePic: null,
        review: "john mayer does it again with his live rendition",
        rating: 10,
        albumImg: "https://m.media-amazon.com/images/I/81lfMW3-N0L._UF1000,1000_QL80_.jpg",
        albumName: "Where The Light Is",
        albumYear: "2016",
        artist: "John Mayer"
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
            

            <div className="flex flex-row justify-between flex-wrap mx-auto mb-24">
                <div className="w-2/3 pr-12">
                    <Titles title="Favorite Albums"/>
                        <div className="text-white flex flex-row justify-center gap-5">
                            <Album album = {{ img: "/blondAlbum.jpg", size: "200"}} />
                            <Album album = {{ img: "/allThingsMustPassAlbum.jpg", size: "200"}} />
                            <Album album = {{ img: "/currentsAlbum.jpg", size: "200"}} />
                            <Album album = {{ img: "/whereTheLightIsAlbum.jpg", size: "200"}} />
                        </div>
                </div>
                
                <AvgReviews />
            </div>

            {/* Recent Reviews: Last 2 reviews from the user */}
            <Titles title="Recent Reviews"/>
            <Review review={ reviewDummy } />
            <div className="border-t border-gray-600 max-w-5xl mx-auto" />
            <Review review={ anotherExample }/>

            {/* Popular Reviews: Two most popular reviews by likes, by the user */}
            <Titles title="Popular Reviews"/>
            <Review review={ reviewDummy } />
            <div className="border-t border-gray-600 max-w-5xl mx-auto" />
            <Review review={ anotherExample }/>

            {/* Following: Avatars of people the user follows */}
            <Titles title="Following"/>
            <div class="flex flex-col justify-center items-left max-w-5xl pb-10">
                <div class="flex gap-2 flex-wrap">
                    { followingDummy }                         
                </div>
            </div>

            {/* Followers: Avatars of people that follow the user */}
            <Titles title="Followers"/>
            <div class="flex flex-col justify-center items-left max-w-5xl pb-10">
                <div class="flex gap-2 flex-wrap">
                    { followingDummy }                         
                </div>
            </div>
            
        </div>
    );
}

export default Profile;