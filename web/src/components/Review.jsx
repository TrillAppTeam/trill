// Components
import Album from "../components/Album"
import Avatar from "../components/Avatar"
import Stars from "../components/Stars"

// Icons
import Heart from '/heart.svg';

function Review(props) {
    const { user, profilePic, rating, review, albumImg, albumName, albumYear, artist} = props.review;

    return (
        <div className="max-w-6xl mx-auto">

            <div className="flex flex-row">

                {/* Album Art */}
                <div className="p-3 m-2">
                    <Album album = {{ img : albumImg, size : "100", name : albumName }} />
                </div>

                <div className="flex flex-col p-3 gap-4 w-4/5">
                    {/* Album Name and Album Year */}
                    <div className="flex flex-row gap-4">
                        <h1 className="text-xl text-gray-200">
                            <span className="font-bold italic">{albumName} </span> 
                            - {artist}
                        </h1>
                        <h1 className="text-xl text-gray-500">{albumYear}</h1>
                    </div>

                    {/* Profile Picture, Rating, and Listen Date */}
                    <div className="flex flex-row gap-4">
                        <Avatar user={{ profilePic: profilePic, firstName: "Ashley", size: "6" }} />
                        <Stars rating={ rating } />
                        
                        <p className="text-sm text-gray-500 my-auto">Listened to by
                            <span className="text-trillBlue"> {user} </span>
                            on 12/10/2022
                        </p>
                    </div>


                    {/* Review */}
                    <p className="text-md">{review}</p>

                    <div className="flex flex-row gap-2 text-gray-500 text-sm">
                        <img src={Heart} width="15" alt="Heart" />
                        <p>Like review</p>
                        <p>2000 likes</p>
                    </div>
                    
                </div>
            </div>

            {/* Border Line */}
            {/* <div className="border-t border-gray-600 max-w-6xl mx-auto" /> */}

        </div>
    );
}

export default Review;