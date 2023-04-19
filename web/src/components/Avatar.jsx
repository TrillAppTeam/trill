import { Link } from "react-router-dom";

const AvatarComp = (props) =>{
    const { profile_picture, username, size} = props.user;
    return (
        <div className="avatar placeholder pb-1">
            <div className={`bg-neutral-focus text-white rounded-full bg-slate-900 ring-2 ring-trillBlue hover:ring-white w-${size} h-${size}`}>
                { profile_picture ? 
                    <img src={ profile_picture } />
                    :
                    <span className={size === "24" ? "text-5xl text-white uppercase" : "text-md text-white uppercase"}>
                        { username ? username[0]: "" }
                    </span> 
                }     
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
                    <div className="tooltip" data-tip={username}>
                        <AvatarComp user={props.user}/>
                    </div>
                </Link> : 
                <AvatarComp user={props.user}/>}
        </>
    );
}

export default Avatar;