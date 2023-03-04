// Components
import Avatar from "./Avatar"

// Dummy Data
{/* <SearchUser user={{
    username: "avwede",
    profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
    size: "11"
}}/> */}

function SearchUser(props) {
    const { profilePic, username, size } = props.user;

    return(
        <div className="flex flex-row flex-wrap py-10 justify-between mx-5">
            {console.log(username)}
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