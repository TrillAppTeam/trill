import { useLocation } from "react-router-dom";

// Components
import AvgReviews from "../components/AvgReviews";
import Titles from "../components/Titles"
import AlbumDetailsReview from "../components/AlbumDetailsReview"

function AlbumDetails() {
    // IMAGE URL
    // ALBUM NAME
    // ALBUM YEAR
    // ARTIST
    // SPOTIFY LINK
    // ARTIST COVER PHOTO ?
    const {state} = useLocation();
    const {name, year, artist, img, link} = state;
    
    let exampleAlbum = {
        "total_tracks": 9,
        "id": "2up3OPMp9Tb4dAKM2erWXQ",
        "images": [
            {
            "url": "https://i.scdn.co/image/ab67616d0000b273bb54dde68cd23e2a268ae0f5",
            "height": 300,
            "width": 300
            }
        ],
        "name": "Midnights",
        "release_date": "2022-12",
        "genres": [
            "Pop",
            "Pop rock"
        ],
        "external_urls": {
            "spotify": "string"
        },
        "artists": [
            {
                "external_urls": {
                    "spotify": "string"
                },
                "followers": {
                "href": "string",
                "total": 0
                },
                "genres": [
                    "Prog rock",
                    "Grunge"
                ],
                "href": "string",
                "id": "string",
                "images": [
                {
                    "url": "https://image-cdn.hypb.st/https%3A%2F%2Fhypebeast.com%2Fwp-content%2Fblogs.dir%2F6%2Ffiles%2F2022%2F10%2Ftaylor-swift-midnights-10th-studio-album-release-0.jpg?w=960&cbr=1&q=90&fit=max",
                    "height": 300,
                    "width": 300
                }
                ],
                "name": "Taylor Swift",
                "popularity": 0,
                "type": "artist",
                "uri": "string"
            }
        ],
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
        <div className="max-w-6xl mx-auto">

            {/* Background Artist Image Section*/}
            <div className="flex justify-center">
                <div className="w-full h-96 overflow-hidden">
                    <div className="h-full">
                        <img className="object-cover w-full h-full opacity-25 rounded-b-xl z-0" 
                            src={exampleAlbum.artists[0].images[0].url} alt="Album Cover" 
                        />
                    </div>
                </div>
            </div>

            <div className="flex flex-row mx-auto justify-between pt-10">
                {/* Album Art Image and Details Section */}
                <div className="flex flex-row z-10">

                    <div className="flex flex-col">
                            { img[0] ? 
                                <img src={img[0].url} alt="Album Image" width="280" height="280" />
                            : 
                                <div className={`w-64 h-64 flex items-center justify-center text-gray-200 bg-gray-700 ring-2 ring-gray-500`}>
                                    <p className="text-xs text-center max-w-full line-clamp-2">{ name || "Click for album details" }</p>
                                </div>
                            }
                            <button className="btn btn-xs bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2">Add Review</button>
                            <button className="btn btn-xs bg-[#383b59] hover:bg-trillBlue hover:text-black mt-2">Add to Listen Later</button>
                    </div>
                    
                    <div className="z-10 pl-10 flex flex-row gap-10">
                        <div className="flex flex-col">
                            <div className="flex flex-row gap-4">
                                <h1 className="text-3xl text-gray-200 w-4/5">
                                    <span className="font-bold italic">{name}</span> 
                                </h1>
                                <h1 className="text-3xl text-gray-500">{year.split('-')[0]}</h1>
                            </div>

                            <p className="text-xl pt-1">by {artist[0].name}</p>

                        </div>
                    </div>
                </div>    

                {/* Average Reviews Section */}
                <div className="z-10">
                    <AvgReviews />
                </div>
            </div>

            {/* Review Section */}
            <div className="pt-10">
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

                <div className="pt-10">
                    <Titles title="Your Review" />
                    <AlbumDetailsReview review={ reviewDummy } />
                </div>
            </div>
            
        </div>
        
      );
}

export default AlbumDetails

