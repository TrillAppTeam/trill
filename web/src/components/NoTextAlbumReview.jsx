import { Link } from "react-router-dom"
import { useQuery } from '@tanstack/react-query';

// Components
import Avatar from "./Avatar"
import Stars from "./Stars"
import Album from "./Album";

function NoTextAlbumReview(props) {
    const { username, profilePic, created_at, updated_at, review_id, album_id, rating } = props.review;
    const { isLoading, data: albumData, error: albumError } = useQuery([`album?albumID=${album_id}`]);

    return (
        <div className="relative max-w-[100px]">
            <div className="ring-2 ring-gray-500 inline-block">
                { !albumData 
                    ? null 
                    : <Album album={{...albumData?.data, size: "150"}}/> 
                }

                <div className="bg-gray-700 px-2 py-2">
                    <div className="text-xs text-left flex flex-row">
                        <Avatar user={{ profilePic: profilePic, username: username, size: "4" }} />
                        <div className="tooltip" data-tip={username}>
                            <Link to={`/User/Profile/${username}`}>
                                <p className="text-md text-gray-300 pl-2 font-bold hover:text-trillBlue line-clamp-1 truncate">{username.length > 8 ? username.slice(0, 8) + '...' : username}</p>
                            </Link>
                        </div>
                        

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

export default NoTextAlbumReview