import { useState } from 'react';
import { useMutation } from '@tanstack/react-query';
import { DateTime } from 'luxon';
import axios from 'axios';
import { Link } from "react-router-dom";

// Components
import Avatar from "../components/Avatar"
import Stars from "../components/Stars"

function AlbumDetailsReview(props) {
    const { user: {username}, created_at, updated_at, review_text, review_id, likes: likesConst, requestor_liked, rating } = props.review;
    const profile_picture = props.review.user.profile_picture


    const like = useMutation(() => { 
        return axios.put(`https://api.trytrill.com/main/likes?reviewID=${review_id}`, {}, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
    });
    const unlike = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/likes?reviewID=${review_id}`, 
            { headers: {'Authorization': `Bearer ${sessionStorage.getItem('access_token')}`}})
    });

    const dateTimeObj = DateTime.fromISO(updated_at ? updated_at : created_at);
    const formattedDate = dateTimeObj.toFormat('MM/dd/yyyy')

    const [likes, setLikes] = useState(likesConst);
    const [isLiked, setIsLiked] = useState(requestor_liked);

    const handleLikeClick = () => {
        if (isLiked) {
            unlike.mutate();
            setLikes(likes - 1);
        } else {
            like.mutate();
            setLikes(likes + 1);
        }
        setIsLiked(!isLiked);
    }
    return (
        <div className="max-w-6xl mx-auto">

            <div className="flex flex-row p-5">
                <Avatar user={{ profile_picture: profile_picture, username: username, size: "12" }} />

                <div className="flex flex-col pl-5 gap-4">
                    {/* Profile Picture, Rating, and Listen Date */}
                    <div className="flex flex-row gap-4 text-md">
                        <Stars rating={rating} />
                        <p className="text-md text-gray-500 my-auto">Listened to by
                            <Link to={`/User/Profile/${username}`}>
                                <span className="text-trillBlue hover:text-white"> @{username} </span>
                            </Link>
                            on  
                            <span className="text-gray-400"> {formattedDate}</span>
                        </p>                   
                    </div>

                     {/* Review */}
                     <p className="text-md text-gray-400">{review_text}</p>
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

                            <p>{likes}{likes === 1 ? " Like": " Likes"}</p>
                        </div>
                        


                </div>
                
            </div>
        </div>
    );
}

export default AlbumDetailsReview;