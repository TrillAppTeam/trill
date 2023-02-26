import { useLocation } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";

import Titles from "../components/Titles";
import Loading from "../components/Loading";
import Album from "../components/Album";

function SearchResults() {
    const { state } = useLocation();
    const { query, type } = state;
    const { isLoading: albumLoad, data: albumData, error: albumError } = useQuery([`albums?query=${query}`]);
    // const { isLoading: userLoad, data: userData, error: userError } = useQuery([`albums?query=${query}`]);
    
    return(
        <div className="max-w-6xl mx-auto pt-8">
            <Titles title={`Search Results for "${query}" in ${type}`} />
            {albumLoad ? <Loading /> :
                albumData?.data.map(album => {
                    return <Album album={{img: album.images[0].url, size: "100", name: album.name}}/>
                })
            }
        </div>
    );
}

export default SearchResults