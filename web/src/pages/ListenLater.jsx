//Components
import Titles from "../components/Titles";
import Album from "../components/Album";

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

function ListenLater() {
    let dummyAlbums = [];
    for (let i = 0; i < 10; i++) {
        dummyAlbums.push(
        <>
            <Album album = {albumDummy} />
        </>
        );
    }
    return (
        <div className="max-w-6xl mx-auto">           

            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-10 pb-10">Don't miss a beat. Save it for later.</h1>
            
            <Titles title="You want to listen to 50 albums" />
            
            {/* <div className="text-white flex flex-row flex-wrap justify-center gap-4 max-w-6xl mx-auto">
                {dummyAlbums}  
            </div> */}

        </div>
    );
}

export default ListenLater;