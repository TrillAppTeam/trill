import React, { useLayoutEffect, useState, useEffect} from 'react';
import { Link, useParams } from "react-router-dom";
import { useQuery, useMutation } from "@tanstack/react-query";
import axios from 'axios';
 
// Components
import Titles from "../components/Titles"
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
    const { isLoading, data: userData} = useQuery([`users${paramString}`], {onSuccess: (data) => {setIsFollowing(data.data.requestor_follows);}});
    const { data: following, refetch: refetchFollowing } = useQuery([`follows?type=getFollowing&username=${userData?.data.username}`], {enabled: !!userData});
    const { data: followers, refetch: refetchFollowers } = useQuery([`follows?type=getFollowers&username=${userData?.data.username}`], {enabled: !!userData});
    const { data: reviewsNew } = useQuery([`reviews?sort=newest&username=${userData?.data.username}`], {enabled: !!userData});
    const { data: reviewsPopular } = useQuery([`reviews?sort=popular&username=${userData?.data.username}`], {enabled: !!userData});
    const { isLoading: favoriteAlbumsLoading, data: favoriteAlbums } = useQuery([`favoritealbums?username=${userData?.data.username}`], {enabled: !!userData});
    
    const follow = useMutation(() => { 
        return axios.post(`https://api.trytrill.com/main/follows?username=${userData?.data.username}`, {}, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
    }, {onSuccess: () => {setIsFollowing(true); refetchFollowing(); refetchFollowers();}});

    const unfollow = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/follows?username=${userData?.data.username}`, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
    }, {onSuccess: () => {setIsFollowing(false); refetchFollowing(); refetchFollowers();}});
    
    const handleFollow = () => {
        follow.mutate();
    }

    const handleUnfollow = () => {
        unfollow.mutate();
    }

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
                    <UserStats albums={userData?.data.review_count || 0} followers={followers?.data?.length || 0} following={following?.data?.length || 0}/>
                </div>
            </div>

            <div className="flex flex-row justify-between flex-wrap mx-auto mb-24">
                <div className="w-2/3 pr-12">
                    <Titles title="Favorite Albums"/>
                        <div className="text-white flex flex-row justify-left gap-5">
                            {favoriteAlbumsLoading 
                            ?   "Loading..."
                            :   Array.isArray(favoriteAlbums?.data) 
                                ? favoriteAlbums.data.map((favoriteAlbum) => (
                                    <Album album={{...favoriteAlbum, size: "150"}} />
                                ))
                                : <h1 className="italic text-trillBlue">No favorite albums.</h1>
                            }
                        </div>
                </div>
                
                {/* <AvgReviews /> */}
            </div>

            {/* Recent Reviews: Last 2 reviews from the user */}
            <Titles title="Recent Reviews"/>
                {reviewsNew?.data?.length > 0 ? (
                <>
                    {reviewsNew?.data?.slice(0, 2).map((review, index, array) => (
                    <div key={review.review_id}>
                        <Review review={review} />
                        {array.length > 1 && index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                    </div>
                    ))}
                </>
                ) : (
                    <h1 className="italic text-trillBlue">No reviews yet.</h1>
                )}
            <div className="pb-10" />

           {/* Popular Reviews: Two most popular reviews by likes, by the user */}
            <Titles title="Popular Reviews"/>
                {reviewsPopular?.data?.length > 0 ? (
                <>
                    {reviewsPopular?.data?.slice(0, 2).map((review, index, array) => (
                    <div key={review.review_id}>
                        <Review review={review} />
                        {array.length > 1 && index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                    </div>
                    ))}
                </>
                ) : (
                    <h1 className="italic text-trillBlue">No reviews yet.</h1>
                )}
            <div className="pb-10" />


            {/* Following: Avatars of people the user follows */}
            <Titles title="Following"/>
            <div className="flex flex-col justify-center items-left max-w-5xl pb-10">
                {following?.data.length > 0 ? (
                    <div className="flex gap-2 flex-wrap">
                    {following?.data.map(user => {return <Avatar key={user.username} user={{profile_picture: user.profile_picture, username: user.username, size: '11'}}/>})}
                    </div>
                ) : (
                    <h1 className="italic text-trillBlue">No following.</h1>
                )}
            </div>

           {/* Followers: Avatars of people that follow the user */}
            <Titles title="Followers"/>
            <div className="flex flex-col justify-center items-left max-w-5xl pb-10">
                {followers?.data.length > 0 ? (
                    <div className="flex gap-2 flex-wrap">
                    {followers?.data.map(user => {return <Avatar key={user.username} user={{profile_picture: user.profile_picture, username: user.username, size: '11'}}/>})}
                    </div>
                ) : (
                    <h1 className="italic text-trillBlue">No followers.</h1>
                )}
            </div>

        </div>}
        </>
    );
}

export default Profile;