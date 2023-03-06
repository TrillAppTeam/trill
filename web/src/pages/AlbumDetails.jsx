import { useLocation } from "react-router-dom";
import { useState } from "react"

// Components
import AvgReviews from "../components/AvgReviews";
import Titles from "../components/Titles"
import AlbumDetailsReview from "../components/AlbumDetailsReview"
import AddReview from "../components/AddReview"

function AlbumDetails() {
    const [ showModal, setShowModal ] = useState(false);

    const { state } = useLocation();
    const { name, year, artist, img, link } = state;

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
                            <button className="btn btn-xs bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2"
                                    onClick={() => setShowModal(!showModal)}>
                                Add Review
                            </button>
                            {showModal ? (
                            <AddReview />
                            ) : null}
                            <button className="btn btn-xs bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2">Add to Listen Later</button>
                    </div>
                    
                    <div className="pl-10 flex flex-row gap-10">
                        <div className="flex flex-col mr-5">
                            <h1 className="text-4xl text-gray-200 font-bold italic">{name}</h1>
                            <h1 className="text-3xl text-gray-600">{year.split('-')[0]}</h1>
                            <p className="text-xl pt-1">by {artist[0].name}</p>
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
                    <h1 className="italic pl-2">You haven't reviewed this album yet. </h1>
                    {/* <AlbumDetailsReview review={ reviewDummy } /> */}
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

