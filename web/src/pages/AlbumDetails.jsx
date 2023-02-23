import AvgReviews from "../components/AvgReviews";

function AlbumDetails() {
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

    return (
        <div className="max-w-6xl mx-auto">
            <div className="relative">
                {/* Background Artist Image */}
                <div className="flex justify-center">
                    <div className="w-full h-96 overflow-hidden">
                        <div className="relative h-full">
                            <img className="object-cover w-full h-full opacity-50 rounded-b-xl z-0" 
                                src={exampleAlbum.artists[0].images[0].url} alt="Album Cover" 
                            />
                        </div>
                        <div className="absolute top-0 left-0 w-full h-full bg-gradient-to-t from-trillPurple via-trillPurple to-transparent"></div>
                    </div>
                </div>

                {/* Album Art Image */}
                <div className="flex flex-row z-10">
                    <div className="z-10">
                        <img className="w-40 h-40" src={exampleAlbum.images[0].url} alt="Album Overlay Image" />
                    </div>

                    <div className="z-10 pl-10 flex flex-row gap-10 justify-between">

                        <div className="flex flex-col">
                            {/* Album Name and Year Released */}
                            <div className="flex flex-row gap-4">
                                <h1 className="text-3xl text-gray-200">
                                    <span className="font-bold italic">{exampleAlbum.name}</span> 
                                </h1>
                                <h1 className="text-3xl text-gray-500">{exampleAlbum.release_date.split('-')[0]}</h1>
                            </div>

                            {/* Artist Name */}
                            <p className="text-lg">by {exampleAlbum.artists[0].name}</p>
                        </div>

                    </div>

                    

                </div>    
            </div>
            
        </div>
        
      );
}

export default AlbumDetails
