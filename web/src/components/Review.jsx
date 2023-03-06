import { useState } from 'react';

// Components
import Album from "../components/Album"
import Avatar from "../components/Avatar"
import Stars from "../components/Stars"

// Icons
import Heart from '/heart.svg';

function Review(props) {
    const { user, profilePic, rating, review, name: albumName, release_date: albumYear, artists: artist } = props.review;

    const [isLiked, setIsLiked] = useState(false);

    const handleLikeClick = () => {
        setIsLiked(!isLiked);
    }

    return (
        <div className="max-w-6xl mx-auto">

            <div className="flex flex-row">

                {/* Album Art */}
                <div className="p-3 m-2">
                    <Album album = {props.review} />
                </div>

                <div className="flex flex-col p-3 gap-4 w-4/5">
                    {/* Album Name and Album Year */}
                    <div className="flex flex-row gap-4">
                        <h1 className="text-xl text-gray-200">
                            <span className="font-bold italic">{albumName} </span> 
                            - {artist[0].name}
                        </h1>
                        <h1 className="text-xl text-gray-500">{albumYear}</h1>
                    </div>

                    {/* Profile Picture, Rating, and Listen Date */}
                    <div className="flex flex-row gap-4">
                        <Avatar user={{ profilePic: profilePic, username: "avwede", size: "6" }} />
                        <Stars rating={ rating } />
                        
                        <p className="text-sm text-gray-500 my-auto">Listened to by
                            <span className="text-trillBlue"> {user} </span>
                            on 12/10/2022
                        </p>
                    </div>


                    {/* Review */}
                    <p className="text-md">{review}</p>
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

export default Review;