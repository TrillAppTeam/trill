import { Link } from "react-router-dom";

const AvatarComp = (props) =>{
    const { profilePic, username, size} = props.user;
    return (
        <div className="tooltip" data-tip={username}>
            <div className="avatar placeholder">
                <div className={`bg-neutral-focus text-white rounded-full ring-2 ring-trillBlue hover:ring-white w-${size} h-${size}`}>
                    { profilePic ? 
                        <img src={ profilePic } />
                        :
                        <span className={size === "24" ? "text-5xl text-white uppercase" : "text-md text-white uppercase"}>
                            { username ? username[0]: "" }
                        </span> 
                    }     
                </div>
            </div>
        </div>
       
    );
}

function Avatar(props) {
    const {username, linkDisabled} = props.user;
    return (
        <>
            {!linkDisabled ? 
                <Link to={`/User/Profile/${username}`}>
                    <AvatarComp user={props.user}/>
                </Link> : 
                <AvatarComp user={props.user}/>}
        </>
    );
}

export default Avatar;