import { useLocation } from "react-router-dom";
import { useState, useEffect } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import axios from "axios"

// Components
import AvgReviews from "../components/AvgReviews";
import Titles from "../components/Titles";
import Avatar from "../components/Avatar"
import AlbumDetailsReview from "../components/AlbumDetailsReview";
import Toast from "../components/Toast";

// Utils
import ReactStars from "react-rating-stars-component";

// Images 
import SpotifySVG from "/spotify.svg"

function AlbumDetails() {
    const [ rating, setRating ] = useState(0);
    const [ reviewText, setReviewText ] = useState("")
    const [ isEditing, setIsEditing ] = useState(false);

    const { state } = useLocation();
    const { name, year, artist, img, link, id } = state;
    const currentUser = sessionStorage.getItem("username");

    const { isLoading, data: myReview, refetch: refetchReview } = useQuery([`reviews?albumID=${id}&username=${currentUser}`]);
    const { data: reviewFromFriends } = useQuery([`reviews?sort=newest&albumID=${id}&following=true`]);
    const { data: popularGlobal, refetch: refetchPopularGlobal } = useQuery([`reviews?sort=popular&albumID=${id}`]);
    const { data: recentGlobal, refetch: refetchRecentGlobal } = useQuery([`reviews?sort=newest&albumID=${id}`]);

    const { data: albumStats, refetch: refetchAlbumStats } = useQuery([`albums?albumID=${id}`]);

    const { data: favoriteAlbums, refetch: refetchFavoriteAlbums } = useQuery([`favoritealbums?username=${currentUser}`]);
    const { data: listenLater, refetch: refetchListenLater } = useQuery([`listenlateralbums?username=${currentUser}`]);

    useEffect(() => {
        setReviewText(myReview?.data.review_text);
    }, [myReview?.data]);

    // Toast 
    const [isSuccess, setIsSuccess] = useState(false);
    const [dismissed, setDismissed] = useState(true);
    const handleDismiss = () => {
        setDismissed(true);
    };
    
    
    const addOrUpdateReview = useMutation(review => { 
        return axios.put(`https://api.trytrill.com/main/reviews?albumID=${id}`, review, 
            { headers: {
                'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`,
                'Content-Type': 'application/json'
                }
            })
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {
        refetchReview();
        refetchAlbumStats();
        refetchPopularGlobal();
        refetchRecentGlobal();
    }} );

    const deleteReview = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/reviews?albumID=${id}`, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {
        refetchReview();
        refetchAlbumStats();
        refetchPopularGlobal();
        refetchRecentGlobal();
    }} );

    const addFavoriteAlbum = useMutation(() => { 
        return axios.post(`https://api.trytrill.com/main/favoritealbums?albumID=${id}`, {}, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                setIsSuccess(false);
                console.log(err);
            })
            .finally(() => {
                setTimeout(() => {
                    setDismissed(true);
                }, 100000);
            }); 
    }, {onSuccess: () => {refetchFavoriteAlbums();}} );

    const deleteFavoriteAlbum = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/favoritealbums?albumID=${id}`, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refetchFavoriteAlbums();}} );

    const addListenLater = useMutation(() => { 
        return axios.post(`https://api.trytrill.com/main/listenlateralbums?albumID=${id}`, {}, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            }) 
    }, {onSuccess: () => {refetchListenLater();}} );

    const deleteListenLater = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/listenlateralbums?albumID=${id}`, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refetchListenLater();}} );

    const ratingChanged = (newRating) => {
        setRating(newRating*2);
    };

    const postReview = () => {
        addOrUpdateReview.mutate({rating: rating, review_text: reviewText})
    }

    const removeReview = () => {
        deleteReview.mutate({rating: rating, review_text: reviewText});
        setReviewText("");
        setRating(0); 
        setData(null);
    }

    const addToFavoriteAlbums = () => {
        addFavoriteAlbum.mutate();
        setDismissed(false);
    }

    const removeFromFavoriteAlbums = () => {
        deleteFavoriteAlbum.mutate();
    }

    const addToListenLater = () => {
        addListenLater.mutate();
    }

    const removeFromListenLater = () => {
        deleteListenLater.mutate();
    }

    return (
        <div className="max-w-5xl mx-auto">
            <div className="flex flex-row mx-auto justify-between pt-10">
                {/* Album Art Image and Details Section */}
                <div className="flex flex-row">
                    <div className="flex flex-col">
                            { img[0] ? 
                                <img src={img[0].url} alt="Album Image" width="260" height="260" />
                            : 
                                <div className={`w-64 h-64 flex items-center justify-center text-gray-200 bg-gray-700 ring-2 ring-gray-500`}>
                                    <p className="text-xs text-center max-w-full line-clamp-2">{ name || "Click for album details" }</p>
                                </div>
                            }

                            {Array.isArray(favoriteAlbums?.data) && favoriteAlbums?.data.some((album) => album.id === id) ? (
                                <button 
                                    className="btn btn-xs bg-trillBlue text-black hover:bg-red-400 mt-2"
                                    onClick={removeFromFavoriteAlbums}
                                >
                                    Remove From Favorite Albums
                                </button>
                            ) : (
                                <button 
                                    className="btn btn-xs text-gray-400 bg-[#383b59] hover:bg-green-500 hover:text-black mt-2 w-full"
                                    onClick={addToFavoriteAlbums}
                                >
                                    Add to Favorite Albums
                                </button>
                            )}



                            {Array.isArray(listenLater?.data) && listenLater?.data.some((album) => album.id === id) ? (
                                <button 
                                    className="btn btn-xs bg-trillBlue text-black hover:bg-red-400 mt-2"
                                    onClick={removeFromListenLater}
                                >
                                    Remove From Listen Later
                                </button>
                            ) : (
                                <button 
                                    className={albumStats?.data?.requestor_reviewed ? "btn btn-xs text-gray-400 bg-gray-800 hover:bg-gray-800 cursor-not-allowed mt-2" : "btn btn-xs text-gray-400 bg-[#383b59] hover:bg-green-500 hover:text-black mt-2" }
                                    onClick={addToListenLater}
                                >
                                    {albumStats?.data?.requestor_reviewed ? "Already Reviewed" : "Add to Listen Later"}
                                </button>
                            )}


                           
                    </div>
                    
                    <div className="pl-10 flex flex-row gap-10">
                        <div className="flex flex-col">
                            <h1 className="text-4xl text-gray-200 font-bold italic mr-5">{name}</h1>
                            <h1 className="text-3xl text-gray-600">{year.split('-')[0]}</h1>
                            <p className="text-xl pt-1 pb-2">by {artist[0].name}</p>
                            
                            <div className="tooltip" data-tip="Open Spotify">
                                <a href={link} target="_blank">
                                    <img src={SpotifySVG} style={{ width: 25, height: 25 }} className="self-center mb-10" />
                                </a>
                            </div>

                            {!dismissed && (
                                <div className="max-w-[350px]">
                                <Toast toast={{
                                    message: "Maximum favorite albums count of 4 reached. Remove an album from your profile to add more!", 
                                    type: "error", 
                                    onDismiss: handleDismiss}} 
                                />
                                </div>
                            )}
                            

                        </div>
                    </div>
                </div>    
                
                <AvgReviews reviewStats={{
                    average: albumStats?.data?.average_rating, 
                    numRatings: albumStats?.data?.num_ratings
                }} />
                
            </div>

            <div className="pt-10">
                <Titles title="Your Review" />
                {myReview && !isEditing
                ?   <>  
                        <div className="flex flex-row justify-between">
                            <div className="justify-left">
                                <AlbumDetailsReview review={myReview.data} />
                            </div>
                            
                            <button 
                                className="mt-5 btn btn-xs bg-gray-700 hover:bg-trillBlue hover:text-black"
                                onClick={() => setIsEditing(true)}
                            >
                                Edit Review
                            </button>
                        </div>
                        
                    </>
                : 
                    <>
                        <div className="flex flex-row p-5">
                            <Avatar user={{ profile_picture: myReview?.data.user.profile_picture, username: currentUser, size: "12" }} />
                            <div className="flex flex-col pl-5 w-full justify-between">
                                {/* Profile Picture, Rating, and Listen Date */}
                                <p className="text-gray-500 pb-2">Review by
                                    <span className="text-gray-400 font-bold"> You</span>
                                </p>                                    
                                
                                {isLoading ? null : <ReactStars
                                    key={myReview?.data.id}
                                    count={5}
                                    onChange={ratingChanged}
                                    size={30}
                                    isHalf={true}
                                    emptyIcon={<i className="far fa-star"></i>}
                                    halfIcon={<i className="fa fa-star-half-alt"></i>}
                                    fullIcon={<i className="fa fa-star"></i>}
                                    activeColor="#ffd700"
                                    value={myReview?.data.rating / 2 || rating}
                                />}
                                <textarea 
                                    rows="3" 
                                    placeholder="This album is..." 
                                    className="bg-trillPurple p-4 my-2 rounded-md resize-none text-gray-400"
                                    value={reviewText} onChange={(e) => setReviewText(e.target.value)}
                                    >
                                </textarea>
                                
                                <div className="flex flex-row items-center">
                                    <button 
                                        type="button" 
                                        className="py-1 mr-3 w-24 text-sm mt-3 font-bold rounded-md text-gray-900 bg-violet-400 hover:text-white"
                                        onClick={() => {
                                            postReview();
                                            setIsEditing(false);
                                        }}
                                        >
                                        {myReview ? "Save" : "Add Review"}
                                    </button>
                                    {myReview ? (
                                        <button 
                                            type="button" 
                                            className="py-1 mr-3 w-24 text-sm mt-3 font-bold rounded-md text-gray-900 bg-red-900 hover:text-white"
                                            onClick={() => {
                                                removeReview();
                                                setIsEditing(false);
                                            }}
                                        >
                                            Delete
                                        </button>
                                    ) : null}


                                    <div className="text-gray-600 pt-3">
                                        {addOrUpdateReview.isLoading ? (
                                            "Saving..."
                                            ) : (
                                                <>
                                                    { addOrUpdateReview.isError ? (
                                                        <div>An error occurred.</div>
                                                    ) : null}
                                        
                                                    { addOrUpdateReview.isSuccess ? <div>Saved</div> : null}
                                                </>
                                        ) }
                                    </div>
                                </div>
                            </div>
                        </div>  
                    </>
                }

                    
                
                <div className="pt-10">
                    <Titles title="Reviews From Friends" />
                    {reviewFromFriends?.data.length == 0 ? <h1 className="italic text-violet-300">Your friends haven't reviewed this album yet.</h1> : null}

                    {reviewFromFriends?.data.slice(0, 2).map((review, index, array) => (
                        <div key={index}>
                            <AlbumDetailsReview review={review} />
                            {array.length > 1 && index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                        </div>
                    ))} 

                </div>

                <div className="pt-10">
                    <Titles title="Popular Reviews Globally" />
                    {popularGlobal?.data.length == 0 ? <h1 className="italic text-violet-300">No one has reviewed this album yet.</h1> : null}
                    
                    {popularGlobal?.data.slice(0, 2).map((review, index, array) => (
                        <div key={index}>
                            <AlbumDetailsReview review={review} />
                            {array.length > 1 && index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                        </div>
                    ))} 
                </div>

                <div className="pt-10">
                    <Titles title="Recent Reviews Globally" />
                    {recentGlobal?.data.length == 0 ? <h1 className="italic text-violet-300">No one has reviewed this album yet.</h1> : null}

                    {recentGlobal?.data.slice(0, 2).map((review, index, array) => (
                        <div key={index}>
                            <AlbumDetailsReview review={review} />
                            {array.length > 1 && index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                        </div>
                    ))} 
                </div>

                <div className="pb-10"/>
            </div>
        </div>
        
      );
}

export default AlbumDetails

