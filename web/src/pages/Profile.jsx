import React, { useLayoutEffect, useState, useEffect} from 'react';
import { Link, useParams } from "react-router-dom";
import { useQuery, useMutation } from "@tanstack/react-query";
import axios from 'axios';
 
// Components
import Titles from "../components/Titles"
import AvgReviews from "../components/AvgReviews"
import UserStats from "../components/UserStats"
import Album from "../components/Album"
import Avatar from "../components/Avatar"
import Review from "../components/Review"
import Loading from '../components/Loading';

function Profile() {
    useLayoutEffect(() => {
        window.scrollTo(0, 0)
    });

    const { user } = useParams();
    const paramString = user ? `?username=${user}` : '';

    const [ isFollowing, setIsFollowing ] = useState(false);
    const { isLoading, data: userData, error: userError } = useQuery([`users${paramString}`]);
    const { data: following, refetch: refetchFollowing } = useQuery([`follows?type=getFollowing&username=${userData?.data.username}`], {enabled: !!userData});
    const { data: followers, refetch: refetchFollowers } = useQuery([`follows?type=getFollowers&username=${userData?.data.username}`], {enabled: !!userData});
    
    const follow = useMutation(() => { 
        return axios.post(`https://api.trytrill.com/main/follows?username=${userData?.data.username}`, {}, 
            { headers: {'Authorization': `Bearer ${localStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refetchFollowing(); refetchFollowers();}});

    const unfollow = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/follows?username=${userData?.data.username}`, 
            { headers: {'Authorization': `Bearer ${localStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refetchFollowing(); refetchFollowers();}});

    useEffect(() => {
        if (followers?.data.users.includes(localStorage.getItem('username'))) {
            setIsFollowing(true);
        } else {
            setIsFollowing(false);
        }
    }, [followers?.data]);
    
    const handleFollow = () => {
        follow.mutate();
    }

    const handleUnfollow = () => {
        unfollow.mutate();
    }

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
                    <Avatar user={{...userData?.data, size: "24", linkDisabled: true}} />

                    <div className="pl-10">
                        <div className="flex gap-2">
                            <h1 className="font-bold text-white text-3xl">{userData?.data.nickname}</h1>
                            
                            {!user ? 
                                <Link to="/User/Settings">
                                    <button className="btn btn-xs bg-gray-700 hover:bg-trillBlue hover:text-black mt-2">Edit Profile</button>
                                </Link> 
                            : 
                                <>
                                    {isFollowing ? 
                                        <button
                                            className="btn btn-xs bg-trillBlue hover:bg-gray-700 text-trillPurple mt-2 hover:text-gray-100"
                                            onClick={handleUnfollow}
                                        >
                                        Following
                                        </button>
                                        : 
                                        <button
                                            className="btn btn-xs bg-gray-700 hover:bg-trillBlue text-gray-100 hover:text-trillPurple mt-2"
                                            onClick={handleFollow}
                                        >
                                        Follow
                                        </button>
                                    }

                                </>
                            }
                        </div>
                        <h1 className="text-xl text-gray-400 italic">@{userData?.data.username}</h1>
                        <h2 className="text-xl pt-2 text-gray-500">{userData?.data.bio}</h2>
                    </div>
                </div>
              
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
                    {following?.data.users.map(user => {return <Avatar key={user} user={{profilePic: null, username: user, size: '11'}}/>})}
                </div>
            </div>

            {/* Followers: Avatars of people that follow the user */}
            <Titles title="Followers"/>
            <div className="flex flex-col justify-center items-left max-w-5xl pb-10">
                <div className="flex gap-2 flex-wrap">
                    {followers?.data.users.map(user => {return <Avatar key={user} user={{profilePic: null, username: user, size: '11'}}/>})}
                </div>
            </div>
        </div>}
        </>
    );
}

export default Profile;