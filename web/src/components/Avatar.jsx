import { Link } from "react-router-dom";

const AvatarComp = (props) =>{
    const { profilePic, firstName, size} = props.user;
    return (
        <div className="avatar placeholder">
            <div className={`bg-neutral-focus text-white rounded-full ring-2 ring-trillBlue hover:ring-white w-${size} h-${size}`}>
                { profilePic ? 
                    <img src={ profilePic } />
                    :
                    <span className="text-md text-white uppercase">
                        { firstName ? firstName[0]: "" }
                    </span> 
                }     
            </div>
        </div>
    );
}
function Avatar(props) {
    const {firstName, linkDisabled} = props.user;
    return (
        <>
            {!linkDisabled ? 
                <Link to={`/User/Profile/${firstName}`}>
                    <AvatarComp user={props.user}/>
                </Link> : 
                <AvatarComp user={props.user}/>}
        </>
    );
}

export default Avatar;