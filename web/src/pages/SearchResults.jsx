import { useLocation } from "react-router-dom";

function SearchResults() {
    const {state} = useLocation();
    
    return(
        <div>
            <p className="text-xl max-w-6xl mx-auto">search results page</p>
        </div>
    );
}

export default SearchResults