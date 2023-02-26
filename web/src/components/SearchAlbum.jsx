// Components
import Album from "../components/Album"
import SpotifySVG from "/spotify.svg"

function SearchAlbum(props) {
    const { img, name, year, artist, spotifyLink } = props.album;
    
    return (
        <div className="max-w-6xl mx-auto">

            <div className="flex flex-row">

                {/* Album Art */}
                <div className="p-3 m-2">
                    <Album album = {{ img : img, size : "100", name : name }} />
                </div>

                <div className="flex flex-col p-3 gap-2 w-4/5">
                    <div className="flex flex-row gap-4">
                        <h1 className="text-2xl text-gray-300 font-bold italic">{name}</h1>
                        <h1 className="text-2xl text-gray-500">{year.split("-")[0]}</h1>
                    </div>
                    <div className="flex flex-row gap-2 items-center">
                        <h1 className="text-md text-gray-400 italic">Album by {artist}</h1>
                        <div className="tooltip" data-tip="Open Spotify">
                            <a href={spotifyLink} target="_blank">
                                <img src={SpotifySVG} style={{ width: 15, height: 14 }} className="self-center" />
                            </a>
                        </div>
                        
                    </div>
                    
                </div>

            </div>
        </div>
    );
}

export default SearchAlbum;