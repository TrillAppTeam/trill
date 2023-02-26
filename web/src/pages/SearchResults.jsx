import { useLocation } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";

import Titles from "../components/Titles";
import Loading from "../components/Loading";
import SearchAlbum from "../components/SearchAlbum";

function SearchResults() {
    const { state } = useLocation();
    const { query, type } = state;
    const { isLoading: albumLoad, data: albumData, error: albumError } = useQuery([`albums?query=${query}`]);
    // const { isLoading: userLoad, data: userData, error: userError } = useQuery([`albums?query=${query}`]);
    
    return(
        <div className="max-w-4xl mx-auto pt-8">
            <Titles title={`${albumData?.data.length} Search Results for "${query}" in ${type}`} />
            {console.log(albumData?.data)}
            {albumLoad ? <Loading /> :
                albumData?.data.map(album => {
                    return <>
                        <SearchAlbum album={{
                            img: album.images[0].url, 
                            name: album.name, 
                            year: album.release_date, 
                            artist: album.artists[0].name, 
                            spotifyLink: album.external_urls.spotify
                        }}/>
                        
                        <div className="border-t border-gray-600 max-w-6xl mx-auto" />
                    </>
                })
            }
        </div>
    );
}

export default SearchResults