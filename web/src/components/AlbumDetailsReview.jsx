import { useState } from 'react';

// Components
import Album from "../components/Album"
import Avatar from "../components/Avatar"
import Stars from "../components/Stars"

// Icons
import Heart from '/heart.svg';

function AlbumDetailsReview(props) {
    const { user, profilePic, rating, review, name: albumName, release_date: albumYear, artists: artist } = props.review;

    const [isLiked, setIsLiked] = useState(false);

    const handleLikeClick = () => {
        setIsLiked(!isLiked);
    }

    return (
        <div className="max-w-6xl mx-auto">

            <div className="flex flex-row p-5">
                <Avatar user={{ profilePic: profilePic, firstName: "Ashley", size: "12" }} />

                <div className="flex flex-col pl-5 gap-4">
                    {/* Profile Picture, Rating, and Listen Date */}
                    <div className="flex flex-row gap-4 text-md">
                        <p className="text-gray-500">Review by
                            <span className="text-gray-400 font-bold"> {user} </span>
                        </p>
                        <Stars rating={ rating } />
                    </div>

                    {/* Review */}
                    <p className="text-md pb-4">{review}</p>
                    <div className="flex flex-row gap-2 text-gray-500 text-sm">
                        <div
                        onClick={handleLikeClick}
                        className="flex gap-1 items-center transition duration-300 ease-in-out hover:text-gray-400 cursor-pointer font-bold"
                        >
                            <p className={`${isLiked ? 'text-red-500' : 'text-gray-500'}`}>
                                ❤︎
                            </p>

                            <p className={`${isLiked ? 'text-gray-300' : ''}`}>
                                {isLiked ? 'Liked' : 'Like review'}
                            </p>
                        </div>
                        <p>2000 likes</p>
                    </div>
                </div>
                
            </div>
        </div>
    );
}

export default AlbumDetailsReview;