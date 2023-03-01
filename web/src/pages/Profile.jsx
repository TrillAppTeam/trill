import React, { useLayoutEffect } from 'react';
import { Link, useParams } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";
 
// Components
import Titles from "../components/Titles"
import AvgReviews from "../components/AvgReviews"
import UserStats from "../components/UserStats"
import Album from "../components/Album"
import Avatar from "../components/Avatar"
import Review from "../components/Review"
import Loading from '../components/Loading';

function Profile() {
    // GET user info
    // GET favoriteAlbums
    // GET following / follower count --> list of these users and their profile pictures
    // GET number of reviewed albums
    // GET recent reviews
    useLayoutEffect(() => {
        window.scrollTo(0, 0)
    });

    const {user} = useParams();
    let paramString = '';
    if (user)
        paramString = `?username=${user}`;

    const {isLoading, data: userData, error: userError} = useQuery([`users${paramString}`]);
    const {data: following, error: followingError} = useQuery([`follows?type=getFollowing&username=${userData?.data.username}`], {enabled: !!userData});
    const {data: followers, error: followerError} = useQuery([`follows?type=getFollowers&username=${userData?.data.username}`], {enabled: !!userData});

    const userAvatar = {
        firstName: "Ashley",
        profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
        size: "24"
    }

    const followingAvatars = {
        firstName: "Ashley",
        profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
        size: "11"
    }

    // const followingDummy = [];
    // for (let i = 0; i < 30; i++) {
    //     followingDummy.push(<Avatar user={ followingAvatars } />);
    // }
    // <AlbumReview album={{ ...albumDummy, size: "100", user: "avwede", rating: 5}} />

    let albumDummy = { 
        "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0"}], 
        "name": "Harry's House",
        "artists": [
            {
                "name": "Harry Styles"
            }
        ],
        "external_urls": {
            "spotify": "https://open.spotify.com/album/5r36AJ6VOJtp00oxSkBZ5h"
        },
        "release_date": "2021",
        "size": "150"
    };

    let reviewDummy = {
        ...albumDummy,
        user: "Ligma Johnson",
        profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
        review: "Harry has done it yet again.",
        rating: 5,
    };

    return (
        <>
        {isLoading ? <Loading/> : <div className="max-w-5xl mx-auto">
            {/* Profile Section */}
            <div className="flex flex-row flex-wrap py-10 justify-between mx-10">
                <div className="flex flex-row m-5">
                    {/* Profile Picture */}
                    <Avatar user={{...userAvatar, linkDisabled: true}} />

                    {/* Name and Bio */}
                    <div className="pl-10">
                        <div className="flex gap-2">
                            <h1 className="font-bold text-white text-3xl">{userData?.data.nickname}</h1>
                            {!user ? <Link to="/User/Settings">
                                <button className="btn btn-xs bg-gray-700 hover:bg-trillBlue hover:text-black mt-2">Edit Profile</button>
                            </Link> : <></>}
                        </div>
                        <h2 className="text-xl pt-2">{userData?.data.bio}</h2>
                    </div>
                </div>
              
                {/* User Statistics */}
                <div className="pt-5">
                    <UserStats albums={30} followers={followers?.data.users.length} following={following?.data.users.length}/>
                </div>
            </div>
            

            <div className="flex flex-row justify-between flex-wrap mx-auto mb-24">
                <div className="w-2/3 pr-12">
                    <Titles title="Favorite Albums"/>
                        <div className="text-white flex flex-row justify-center gap-5">
                            <Album album = {albumDummy} />
                            <Album album = {albumDummy} />
                            <Album album = {albumDummy} />
                            <Album album = {albumDummy} />
                        </div>
                </div>
                
                <AvgReviews />
            </div>

            {/* Recent Reviews: Last 2 reviews from the user */}
            <Titles title="Recent Reviews"/>
            <Review review={ reviewDummy } />
            <div className="border-t border-gray-600 max-w-5xl mx-auto" />
            <Review review={ reviewDummy }/>

            {/* Popular Reviews: Two most popular reviews by likes, by the user */}
            <Titles title="Popular Reviews"/>
            <Review review={ reviewDummy } />
            <div className="border-t border-gray-600 max-w-5xl mx-auto" />
            <Review review={ reviewDummy }/>

            {/* Following: Avatars of people the user follows */}
            <Titles title="Following"/>
            <div className="flex flex-col justify-center items-left max-w-5xl pb-10">
                <div className="flex gap-2 flex-wrap">
                    {following?.data.users.map(user => {return <Avatar user={{profilePic: null, firstName: user, size: '11'}}/>})}
                </div>
            </div>

            {/* Followers: Avatars of people that follow the user */}
            <Titles title="Followers"/>
            <div className="flex flex-col justify-center items-left max-w-5xl pb-10">
                <div className="flex gap-2 flex-wrap">
                    {followers?.data.users.map(user => {return <Avatar user={{profilePic: null, firstName: user, size: '11'}}/>})}
                </div>
            </div>
        </div>}
        </>
    );
}

export default Profile;