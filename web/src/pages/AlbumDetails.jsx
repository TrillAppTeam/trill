import { useLocation } from "react-router-dom";
import { useState, useEffect } from "react";
import { useQuery, useMutation } from "@tanstack/react-query";
import axios from "axios"

// Components
import AvgReviews from "../components/AvgReviews";
import Titles from "../components/Titles";
import AlbumDetailsReview from "../components/AlbumDetailsReview";
import ReactStars from "react-rating-stars-component";

// Images 
import SpotifySVG from "/spotify.svg"

function AlbumDetails() {
    const [ showModal, setShowModal ] = useState(false);
    const [ rating, setRating ] = useState(0);
    const [ reviewText, setReviewText ] = useState("")
    const { state } = useLocation();
    const { name, year, artist, img, link, id} = state;
    const currentUser = localStorage.getItem("username");

    const {isLoading, data, error, refetch: refetchReview} = useQuery([`reviews?albumID=${id}&username=${currentUser}`]);
    
    useEffect(() => {
        setReviewText(data?.data.review_text);
    }, [data?.data]);
    
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
    }, {onSuccess: () => {refetchReview();}});

    const ratingChanged = (newRating) => {
        setRating(newRating*2);
    };

    const postReview = () => {
        rate.mutate({rating: rating, review_text: reviewText})
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
        review: "Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.Harry has done it yet again.",
        rating: 5,
    };

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
                            <button className="btn btn-xs bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2">Add to Favorite Albums</button>
                            <button className="btn btn-xs bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2">Add to Listen Later</button>
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
                <div className="pt-10">
                    <Titles title="Your Review" />
                    {data ? null: <h1 className="italic">You haven't reviewed this album yet.</h1>}

                    {/* <button className="btn btn-xs bg-[#383b59] mb-4 hover:bg-trillBlue hover:text-black mt-2"
                            onClick={() => setShowModal(!showModal)}>
                        Add Review
                    </button> */}
                    <div className="flex flex-col p-5 shadow-sm rounded-xl lg:p-8 bg-[#383b59] text-gray-100">
                            <div className="flex flex-col items-center w-full">
                                {/* <h2 className="text-3xl font-semibold text-center">Rate and Review</h2> */}
                                {isLoading ? null : <ReactStars
                                    count={5}
                                    onChange={ratingChanged}
                                    size={40}
                                    isHalf={true}
                                    emptyIcon={<i className="far fa-star"></i>}
                                    halfIcon={<i className="fa fa-star-half-alt"></i>}
                                    fullIcon={<i className="fa fa-star"></i>}
                                    activeColor="#ffd700"
                                    value={data?.data.rating / 2 || rating}
                                />}
                                <div className="flex flex-col w-full">
                                    <textarea 
                                        rows="3" 
                                        placeholder="This album is..." 
                                        className="bg-[#383b59] p-4 rounded-md resize-none text-gray-200"
                                        value={reviewText} onChange={(e) => setReviewText(e.target.value)}
                                     ></textarea>
                                    <button 
                                    type="button" 
                                    className="py-3 text-lg mt-6 font-bold rounded-md text-gray-900 bg-violet-400"
                                    onClick={postReview}
                                    >Add Review</button>
                                </div>
                            </div>
                        </div>
                    {/* { showModal ? 
                        <div className="flex flex-col p-5 shadow-sm rounded-xl lg:p-8 bg-[#383b59] text-gray-100">
                            <div className="flex flex-col items-center w-full">
                                <h2 className="text-3xl font-semibold text-center">Rate and Review</h2>
                                {isLoading ? null : <ReactStars
                                    count={5}
                                    onChange={ratingChanged}
                                    size={40}
                                    isHalf={true}
                                    emptyIcon={<i className="far fa-star"></i>}
                                    halfIcon={<i className="fa fa-star-half-alt"></i>}
                                    fullIcon={<i className="fa fa-star"></i>}
                                    activeColor="#ffd700"
                                    value={data?.data.rating / 2}
                                />}
                                <div className="flex flex-col w-full">
                                    <textarea 
                                        rows="3" 
                                        placeholder="This album is..." 
                                        className="bg-[#383b59] p-4 rounded-md resize-none text-gray-200"
                                        value={reviewText} onChange={(e) => setReviewText(e.target.value)}
                                     ></textarea>
                                    <button 
                                    type="button" 
                                    className="py-3 text-lg mt-6 font-bold rounded-md text-gray-900 bg-violet-400"
                                    onClick={postReview}
                                    >Add Review</button>
                                </div>
                            </div>
                        </div>
                        : 
                        null 
                    } */}
                </div>
                
                <div className="pt-10">
                    <Titles title="Reviews From Friends" />
                    <AlbumDetailsReview review={ reviewDummy } />
                    <div className="border-t border-gray-600 max-w-6xl mx-auto" />
                    <AlbumDetailsReview review={ reviewDummy }/>
                </div>

                <div className="pt-10">
                    <Titles title="Popular Reviews" />
                    <AlbumDetailsReview review={ reviewDummy } />
                    <div className="border-t border-gray-600 max-w-6xl mx-auto" />
                    <AlbumDetailsReview review={ reviewDummy }/>
                </div>

                <div className="pt-10">
                    <Titles title="Recent Reviews" />
                    <AlbumDetailsReview review={ reviewDummy } />
                    <div className="border-t border-gray-600 max-w-6xl mx-auto" />
                    <AlbumDetailsReview review={ reviewDummy }/>
                </div>
            </div>
        </div>
        
      );
}

export default AlbumDetails

