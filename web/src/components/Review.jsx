import { useMutation, useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { DateTime } from 'luxon';
import axios from 'axios';

// Components
import Album from "../components/Album";
import Avatar from "../components/Avatar";
import Stars from "../components/Stars";
import Loading from './Loading';

function Review(props) {
    const { username, profilePic, created_at, updated_at, review_text, review_id, artists, album_id, likes: likesConst, requestor_liked, rating } = props.review;
    const { isLoading, data: albumData, error: albumError } = useQuery([`album?albumID=${album_id}`]);

    const like = useMutation(() => { 
        return axios.put(`https://api.trytrill.com/main/likes?reviewID=${review_id}`, {}, 
            { headers: {'Authorization': `Bearer ${localStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
    });
    const unlike = useMutation(() => { 
        return axios.delete(`https://api.trytrill.com/main/likes?reviewID=${review_id}`, 
            { headers: {'Authorization': `Bearer ${localStorage.getItem('access_token')}`}})
            .then((res) => {
                return res;
            })
            .catch((err) => {
                console.log(err);
            })
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
            {isLoading ? <Loading /> : 
                !albumData ? null :
                <div className="flex flex-row">
                    
                    {/* Album Art */}
                    <div className="p-3 m-2">
                        <Album album = {{...albumData?.data, size: "100"}} />
                    </div>
                    <div className="flex flex-col p-3 gap-4 w-4/5">
                        {/* Album Name and Album Year */}
                        <div className="flex flex-row gap-4">
                            <h1 className="text-xl text-gray-200">
                                <span className="font-bold italic">{albumData.data.name} </span> 
                                - {albumData.data.artists[0].name}
                            </h1>
                            <h1 className="text-xl text-gray-500">{albumData.data.release_date.split("-")[0]}</h1>
                        </div>

                        {/* Profile Picture, Rating, and Listen Date */}
                        <div className="flex flex-row gap-4">
                            <Avatar user={{ profilePic: profilePic, username: username, size: "6" }} />
                            <Stars rating={ rating } />
                            
                            <p className="text-sm text-gray-500 my-auto">Listened to by
                                <span className="text-trillBlue"> {username} </span>
                                on  
                                <span className="text-gray-400"> {formattedDate}</span>
                            </p>
                        </div>


                        {/* Review */}
                        <p className="text-md">{review_text}</p>
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
            </div>}
        </div>
    );
}

export default Review;