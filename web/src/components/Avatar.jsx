function Avatar(props) {
    const { profilePic, firstName } = props.user;

    return (
        <div className="avatar placeholder">
            <div className="bg-neutral-focus text-neutral-content rounded-full w-24 ring-2 ring-trillBlue">
                { profilePic ? 
                    <img src={ profilePic } />
                    :
                    <span className="text-2xl text-white">{firstName ? firstName[0]: ""}</span> }      
            </div>
        </div> 
    );
}

export default Avatar