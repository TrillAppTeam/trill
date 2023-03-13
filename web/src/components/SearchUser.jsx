// Components
import Avatar from "./Avatar"

function SearchUser(props) {
    const { profilePic, username, size } = props.user;

    return(
        <div className="flex flex-row flex-wrap py-2 justify-between mx-5">
            <div className="flex flex-row">

                <div className="pt-1">
                    <Avatar user={{profilePic: profilePic, username: username, size: size}}/>
                </div>

                <div className="flex flex-col pl-10">
                    <h1 className="font-bold text-gray-200 text-lg">{username}</h1>
                    <h1 className="text-sm">61 Followers, Following 51</h1>
                </div>

            </div>
        </div>
    );
}

export default SearchUser