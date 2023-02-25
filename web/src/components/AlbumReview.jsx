import { Link } from "react-router-dom"

// Components
import Avatar from "./Avatar"
import Stars from "./Stars"

function AlbumReview(props) {
    const { img, size, user, albumName, rating} = props.album;

    return (
        <div className="relative transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-105 max-w-[100px]">

            <Link to="/User/AlbumDetails">
                <div className="ring-2 ring-gray-500 inline-block">
                    {/* Album Art */}
                    <img src={img} width={size} height={size}/>

                    {/* Overlay mask with album name */}
                    <div className={`max-w-[100px] max-h-[100px] absolute inset-0 flex items-center justify-center text-white bg-black bg-opacity-50 opacity-0 hover:opacity-100 transition-opacity`}>
                        <p className="text-xs text-center line-clamp-2">{ albumName || "Click for album details" }</p>
                    </div>

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
            </Link>
        </div>
      );
}

export default AlbumReview