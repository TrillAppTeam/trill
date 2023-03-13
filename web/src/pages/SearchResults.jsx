import { useLocation } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";

import Titles from "../components/Titles";
import Loading from "../components/Loading";
import SearchAlbum from "../components/SearchAlbum";
import SearchUser from "../components/SearchUser";

function SearchResults() {
    const { state } = useLocation();
    const { query, type } = state;
    const { isLoading: albumLoad, data: albumData, error: albumError } = useQuery([`albums?query=${query}`], {enabled: type === "Albums"});
    const { isLoading: userLoad, data: userData, error: userError } = useQuery([`users?search=${query}`], {enabled: type === "Users"});
    
    return(
        <div className="max-w-4xl mx-auto pt-8">
            {type == "Users" ? 
                <div>
                    <Titles title={`Search Results for "${query}" in ${type}`} />
                    {userLoad ? <Loading /> :
                        userData?.data.map(user => {
                            return <>
                                {console.log(user)}
                                <SearchUser user={{
                                    username: user.username,
                                    profilePic: user.profilePic,
                                    size: "11"
                                }}/>
                    
                                <div className="m-5 border-t border-gray-600 max-w-6xl mx-auto" />
                            </>
                        })   
                    }
                </div> 
                :
                <div>
                    <Titles title={`${albumData?.data.length == undefined ? "" : albumData?.data.length} Search Results for "${query}" in ${type}`} />
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