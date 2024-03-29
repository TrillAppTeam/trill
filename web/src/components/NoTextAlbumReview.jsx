import { Link } from "react-router-dom"
import { DateTime } from 'luxon';

// Components
import Avatar from "./Avatar"
import Stars from "./Stars"
import Album from "./Album"

function NoTextAlbumReview(props) {
    const { user: {username}, created_at, updated_at, rating } = props.review;
    const { images, name, release_date, artists, external_urls, id } = props.review.album;
    const profile_picture = props.review.user.profile_picture

    const album = { 
        images,
        name,
        release_date,
        artists,
        external_urls,
        id
      };
    
    const dateTimeObj = DateTime.fromISO(updated_at ? updated_at : created_at);
    const formattedDate = dateTimeObj.toFormat('MMM dd')

    return (
        <div className="relative max-w-[100px]">
            <div className="ring-2 ring-gray-500 inline-block">
                <Album album={{...album, size: "150"}}/> 

                <div className="bg-gray-700 px-2 py-1 pt-2">
                    <div className="text-xs text-left flex flex-row">
                        <div className="pt-1">
                            <Avatar user={{ profile_picture: profile_picture, username: username, size: "4" }} />
                        </div>
                        
                        <div className="tooltip" data-tip={username}>
                            <Link to={`/User/Profile/${username}`}>
                                <p className="text-md text-gray-300 pl-2 pt-1 font-bold hover:text-trillBlue line-clamp-1 truncate">{username.length > 6 ? username.slice(0, 6) + '...' : username}</p>
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
            
            <div className="flex flex-row justify-between text-xs pt-1 text-gray-400">
                <Stars rating={rating} />
                <p>{formattedDate}</p>
            </div>
        </div>
      );
}

export default NoTextAlbumReview