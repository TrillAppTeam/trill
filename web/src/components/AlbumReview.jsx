import { Link } from "react-router-dom";
import Album from "./Album";

// Components
import Avatar from "./Avatar"
import Stars from "./Stars"

function AlbumReview(props) {
    const {name, user, rating} = props.album;

    return (
        <div className="relative max-w-[100px]">
            <div className="ring-2 ring-gray-500 inline-block">
                {/* Album Art */}
                <Album album={props.album}/> 

                <div className="bg-gray-700 px-2 py-2">
                    <div className="text-xs text-left flex flex-row">
                        <Avatar user={{ profilePic: null, firstName: user, size: "4" }} />
                        <p className="text-md pl-2 font-bold">{user}</p>
                    </div>
                </div>
            </div>
            
            <div className="flex flex-row justify-between text-xs pt-1 text-gray-400">
                <Stars rating={rating} />
                <p>Feb 18</p>
            </div>
        </div>
      );
}

export default AlbumReview