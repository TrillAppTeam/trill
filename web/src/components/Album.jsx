import { Link } from "react-router-dom"

function Album(props) {
    const {images: img, name, release_date: year, artists, external_urls: spotifyLink, size, id} = props.album;
    return (
        <div className="relative transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-105">
            <Link to="/User/AlbumDetails" state={{name: name, year: year, artist: artists, img: img, link: spotifyLink.spotify, id: id}}>
                { img[0] ? 
                    <div>
                        {/* Album Art */}
                        <img className="ring-2 ring-gray-500" src={img[0]?.url} width={size} height={size} />

                        {/* Overlay mask with album name */}
                        <div className={`max-w-[${size}px] max-h-[${size}px] absolute inset-0 flex items-center justify-center text-white bg-black bg-opacity-50 opacity-0 hover:opacity-100 transition-opacity`}>
                            <p className="text-xs text-center max-w-full line-clamp-2">{ name || "Click for album details" }</p>
                        </div>
                    </div>
                    
                    : 

                    <div className={`w-[100px] h-[100px] flex items-center justify-center text-gray-200 bg-gray-700 ring-2 ring-gray-500`}>
                        <p className="text-xs text-center max-w-full line-clamp-2">{ name || "Click for album details" }</p>
                    </div>
                }
            </Link>
        </div>
      );
}

export default Album