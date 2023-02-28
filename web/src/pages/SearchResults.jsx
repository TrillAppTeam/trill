import { useLocation } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";

import Titles from "../components/Titles";
import Loading from "../components/Loading";
import SearchAlbum from "../components/SearchAlbum";
import SearchUser from "../components/SearchUser";

function SearchResults() {
    const { state } = useLocation();
    const { query, type } = state;
    const { isLoading: albumLoad, data: albumData, error: albumError } = useQuery([`albums?query=${query}`]);
    // const { isLoading: userLoad, data: userData, error: userError } = useQuery([`albums?query=${query}`]);
    
    return(
        <div className="max-w-4xl mx-auto pt-8">
            <Titles title={`${albumData?.data.length == undefined ? "" : albumData?.data.length} Search Results for "${query}" in ${type}`} />

            {type == "Users" ? 
                <div>
                    <SearchUser user={{
                    username: "avwede",
                    profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
                    size: "11"
                    }}/>
                </div> 
                : 
                <div>
                    {/* Remove Eventually!! */}
                    {console.log(albumData?.data)}
                    {albumLoad ? <Loading /> :
                        albumData?.data.map(album => {
                            return <>
                                <SearchAlbum album={album}/>
                                
                                <div className="border-t border-gray-600 max-w-6xl mx-auto" />
                            </>
                        })
                    }
                </div>
            }

        </div>
    );
}

export default SearchResults