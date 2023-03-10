import { useLocation } from "react-router-dom";
import { useState, useEffect } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import axios from "axios"

// Components
import AvgReviews from "../components/AvgReviews";
import Titles from "../components/Titles";
import Avatar from "../components/Avatar"
import AlbumDetailsReview from "../components/AlbumDetailsReview";

// Utils
import ReactStars from "react-rating-stars-component";

// Images 
import SpotifySVG from "/spotify.svg"

function AlbumDetails() {
    const [ rating, setRating ] = useState(0);
    const [ reviewText, setReviewText ] = useState("")
    const { state } = useLocation();
    const { name, year, artist, img, link, id } = state;
    const currentUser = localStorage.getItem("username");

    const { isLoading, data, refetch: refetchReview } = useQuery([`reviews?albumID=${id}&username=${currentUser}`]);
    const { data: reviewFromFriends } = useQuery([`reviews?sort=newest&albumID=${id}&following=true`]);
    const { data: popularGlobal } = useQuery([`reviews?sort=popular&albumID=${id}`]);
    const { data: recentGlobal } = useQuery([`reviews?sort=newest&albumID=${id}`]);

    const { data: favoriteAlbums, refetch: refecthFavoriteAlbums } = useQuery([`favoritealbums?username=${currentUser}`]);
    
    useEffect(() => {
        setReviewText(data?.data.review_text);
    }, [data?.data]);

    
    const [isLiked, setIsLiked] = useState(false);

    const handleLikeClick = () => {
        setIsLiked(!isLiked);
    }
    
    const rate = useMutation(review => { 
        return axios.put(`https://api.trytrill.com/main/reviews?albumID=${id}`, review, 
            { headers: {
                'Authorization': `Bearer ${localStorage.getItem('access_token')}`,
                'Content-Type': 'application/json'
                }
            })
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refetchReview();}} );

    const addFavoriteAlbum = useMutation(() => { 
        return axios.post(`https://api.trytrill.com/main/favoritealbums?albumID=${id}`, {}, 
            { headers: {'Authorization': `Bearer ${localStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refecthFavoriteAlbums();}} );

    const deleteFavoriteAlbum = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/favoritealbums?albumID=${id}`, 
            { headers: {'Authorization': `Bearer ${localStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    }, {onSuccess: () => {refecthFavoriteAlbums();}} );

    const ratingChanged = (newRating) => {
        setRating(newRating*2);
    };

    const postReview = () => {
        rate.mutate({rating: rating, review_text: reviewText})
    }

    const addToFavoriteAlbums = () => {
        addFavoriteAlbum.mutate();
    }

    const removeFromFavoriteAlbums = () => {
        deleteFavoriteAlbum.mutate();
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

                            {favoriteAlbums?.data.some((album) => album.id === id) ? (
                                <button 
                                    className="btn btn-xs bg-trillBlue text-black hover:bg-red-400 mt-2"
                                    onClick={removeFromFavoriteAlbums}
                                >
                                    Remove From Favorite Albums
                                </button>
                            ) : (
                                <button 
                                    className="btn btn-xs text-gray-400 bg-[#383b59] hover:bg-green-500 hover:text-black mt-2"
                                    onClick={addToFavoriteAlbums}
                                >
                                    Add to Favorite Albums
                                </button>
                            )}

                            <button className="btn btn-xs text-gray-400 bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2">Add to Listen Later</button>
                    </div>
                    
                    <div className="pl-10 flex flex-row gap-10">
                        <div className="flex flex-col">
                            <h1 className="text-4xl text-gray-200 font-bold italic mr-5">{name}</h1>
                            <h1 className="text-3xl text-gray-600">{year.split('-')[0]}</h1>
                            <p className="text-xl pt-1 pb-2">by {artist[0].name}</p>
                            
                            <div className="tooltip" data-tip="Open Spotify">
                                <a href={link} target="_blank">
                                    <img src={SpotifySVG} style={{ width: 25, height: 25 }} className="self-center" />
                                </a>
                            </div>

                        </div>
                    </div>
                </div>    

                {/* Average Reviews Section */}
                <AvgReviews />
            </div>

            {/* Review Section */}
            <div className="pt-10">
                    <Titles title="Your Review" />
                    {data ? null: <h1 className="italic text-violet-300">You haven't reviewed this album yet.</h1>}
   
                    <div className="flex flex-row p-5">
                        <Avatar user={{ profilePic: null, username: currentUser, size: "12" }} />

                        <div className="flex flex-col pl-5 w-full justify-between">
                            {/* Profile Picture, Rating, and Listen Date */}
                            <p className="text-gray-500 pb-2">Review by
                                <span className="text-gray-400 font-bold"> You</span>
                            </p>                                    
                            
                            {isLoading ? null : <ReactStars
                                count={5}D
                                onChange={ratingChanged}
                                size={30}
                                isHalf={true}
                                emptyIcon={<i className="far fa-star"></i>}
                                halfIcon={<i className="fa fa-star-half-alt"></i>}
                                fullIcon={<i className="fa fa-star"></i>}
                                activeColor="#ffd700"
                                value={data?.data.rating / 2 || rating}
                            />}

                            {/* Review Text Area */}
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
                                    className="py-1 mr-3 w-24 text-sm mt-3 font-bold rounded-md text-gray-900 bg-violet-400 hover:text-violet-800"
                                    onClick={postReview}
                                    >
                                    {data ? "Edit Review" : "Add Review"}
                                </button>

                                <div className="text-gray-600 pt-3">
                                    {rate.isLoading ? (
                                        "Saving..."
                                        ) : (
                                            <>
                                                { rate.isError ? (
                                                    <div>An error occurred.</div>
                                                ) : null}
                                    
                                                { rate.isSuccess ? <div>Saved</div> : null}
                                            </>
                                    ) }
                                </div>
                            </div>
                            

                            {/* Only show likes if the review has been posted */}
                            {data ? 
                                <div className="flex flex-row gap-2 text-gray-500 text-sm pt-5">
                                    <div onClick={handleLikeClick}
                                        className="flex gap-1 items-center transition duration-300 ease-in-out hover:text-gray-400 cursor-pointer font-bold"
                                    >
                                        <p className={`${isLiked ? 'text-red-500' : 'text-gray-500'}`}>
                                            ❤︎
                                        </p>

                                        <p className={`${isLiked ? 'text-gray-300' : ''}`}>
                                            {isLiked ? 'Liked' : 'Like review'}
                                        </p>
                                    </div>
                                    <p>0 likes</p>
                                </div>
                               : null
                            }
                        </div>
    
                </div>
                
                <div className="pt-10">
                    <Titles title="Reviews From Friends" />
                    {console.log(reviewFromFriends)}
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

