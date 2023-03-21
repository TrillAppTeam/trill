import { useLocation } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";

import Titles from "../components/Titles";
import Loading from "../components/Loading";
import SearchAlbum from "../components/SearchAlbum";
import SearchUser from "../components/SearchUser";

function SearchResults() {
    const { state } = useLocation();
    const { query, type } = state;
    const { isLoading: albumLoad, data: albumData } = useQuery([`albums?query=${query}`], {enabled: type === "Albums"});
    const { isLoading: userLoad, data: userData } = useQuery([`users?search=${query}`], {enabled: type === "Users"});
    
    return(
        <div className="max-w-4xl mx-auto pt-8">
            {type == "Users" ? 
                <div>
                    <Titles title={`Search Results for "${query}" in ${type}`} />
                    {userLoad ? <Loading /> :
                        userData?.map(user => {
                            return <>
                                <SearchUser user={{
                                    username: user.username,
                                    profile_picture: user.profile_picture,
                                    size: "11"
                                }}/>
                    
                                <div className="m-5 border-t border-gray-600 max-w-6xl mx-auto" />
                            </>
                        })   
                    }
                </div> 
                :
                <div>
                    <Titles title={`${albumData?.length == undefined ? "" : albumData?.length} Search Results for "${query}" in ${type}`} />
                    {albumLoad ? <Loading /> :
                        albumData?.map(album => {
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