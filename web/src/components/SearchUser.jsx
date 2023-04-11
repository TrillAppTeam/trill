import { useQuery } from "@tanstack/react-query";

// Components
import Avatar from "./Avatar"

function SearchUser(props) {
    const { profile_picture, username, size } = props.user;
    const { data: following} = useQuery([`follows?type=getFollowing&username=${username}`],  {retry: 3});
    const { data: followers} = useQuery([`follows?type=getFollowers&username=${username}`], {retry: 3});

    return(
        <div className="flex flex-row flex-wrap py-2 justify-between mx-5">
            <div className="flex flex-row">
                <div className="pt-1">
                    <Avatar user={{profile_picture: profile_picture, username: username, size: size}}/>
                </div>

                <div className="flex flex-col pl-10">
                    <h1 className="font-bold text-gray-200 text-lg">{username}</h1>
                    <h1 className="text-sm text-gray-400">{followers?.length} Followers, Following {following?.length}</h1>
                </div>

            </div>
        </div>
    );
}

export default SearchUser