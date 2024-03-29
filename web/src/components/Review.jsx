import { useMutation, useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { DateTime } from 'luxon';
import axios from 'axios';
import { Link } from "react-router-dom"

// Components
import Album from "../components/Album";
import Avatar from "../components/Avatar";
import Stars from "../components/Stars";

function Review(props) {
    const { user: {username}, created_at, updated_at, review_text, review_id, likes: likesConst, requestor_liked, rating } = props.review;
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
            <div className="flex flex-row">
                
                {/* Album Art */}
                <div className="p-3 m-2">
                    <Album album = {{...album, size: "130"}} />
                </div>
                
                <div className="flex flex-col p-3 gap-4 w-4/5">
                    {/* Album Name and Album Year */}
                    <div className="flex flex-row gap-4">
                        <h1 className="text-xl text-gray-200">
                        <Link to="/User/AlbumDetails" state={{name: album.name, year: album.release_date, artist: album.artists, img: album.images, link: album.external_urls.spotify, id: album.id }}>
                            <span className="font-bold italic hover:text-violet-300">{album.name} </span> 
                        </Link>
                            - {album.artists ? album.artists[0].name : "No Artist"}
                        </h1>
                        <h1 className="text-xl text-gray-500">{album.release_date.split("-")[0]}</h1>
                    </div>

                    {/* Profile Picture, Rating, and Listen Date */}
                    <div className="flex flex-row gap-4">
                        <Avatar user={{ profile_picture: profile_picture, username: username, size: "6" }} />
                        <Stars rating={ rating } />
                        
                        <p className="text-md text-gray-500">Reviewed by
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

export default Review;