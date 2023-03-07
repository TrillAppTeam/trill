import Review from "../components/Review"
import Titles from "../components/Titles"

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
    "size": "100"
}

let reviewDummy = {
    ...albumDummy,
    user: "Ligma Johnson",
    profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
    review: "Harry has done it yet again.",
    rating: 5,
}

function FriendsFeed() {
    return (
        <div className="max-w-6xl mx-auto">            
            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-10 pb-10">Discover new songs together.</h1>
            <Titles title="Friends Feed" />
            
            {/* <Review review={reviewDummy}/>
            <div className="border-t border-gray-600 max-w-6xl mx-auto" />
            <Review review={reviewDummy}/> */}
        </div>
    );
}

export default FriendsFeed