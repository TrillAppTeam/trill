import { Link } from "react-router-dom"

function Album(props) {
    const { img, size, name } = props.album;
    
    return (
        <div className="relative transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110">
            <Link to="/User/AlbumDetails">

                {/* Album Art */}
                <img className="ring-2 ring-gray-500" src = { img } width = { size } height = { size }/>

                {/* Overlay mask with album name */}
                <div className="absolute inset-0 flex items-center justify-center text-white bg-black bg-opacity-50 opacity-0 hover:opacity-100 transition-opacity">
                    <p className="text-xs text-center max-w-full line-clamp-2">{ name || "Click for album details" }</p>
                </div>

            </Link>
        </div>
      );
}

export default Album