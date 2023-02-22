function UserStats(props) {
    const {albums, following, followers} = props;
    return (
        <div className="text-gray-200 body-font max-w-sm">
            <div className="container px-5 mx-auto">

                <div className="flex flex-wrap -m-4 text-center">
                
                <div className="p-4 md:w-1/3 sm:w-1/2 w-full">
                    <div className="border-2 border-gray-700 px-3 py-3 rounded-lg">

                    <h2 className="title-font font-bold text-2xl text-trillBlue">{albums}</h2>
                    <p className="leading-relaxed">Albums</p>
                    </div>
                </div>

                <div className="p-4 md:w-1/3 sm:w-1/2 w-full">
                    <div className="border-2 border-gray-700 px-3 py-3 rounded-lg">
                    <h2 className="title-font font-bold text-2xl text-trillBlue">{following}</h2>
                    <p className="leading-relaxed">Following</p>
                    </div>
                </div>

                <div className="p-4 md:w-1/3 sm:w-1/2 w-full">
                    <div className="border-2 border-gray-700 px-3 py-3 rounded-lg">
                    <h2 className="title-font text-2xl text-trillBlue font-bold">{followers}</h2>
                    <p className="leading-relaxed">Followers</p>
                    </div>
                </div>
            
                </div>
            </div>
        </div>
    );
}

export default UserStats