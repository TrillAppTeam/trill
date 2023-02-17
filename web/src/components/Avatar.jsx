function Avatar(props) {
    const { profilePic, firstName, size } = props.user;

    return (
        <div className="avatar placeholder">
            <div className={`bg-neutral-focus text-white rounded-full ring-2 ring-trillBlue hover:ring-white w-${size} h-${size}`}>
                { profilePic ? 
                    <img src={ profilePic } className={`w-${size} h-${size}`}/>
                    :
                    <span className="text-xl text-white">{firstName ? firstName[0]: ""}</span> 
                }     
            </div>
        </div> 
    );
}

export default Avatar