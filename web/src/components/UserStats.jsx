function UserStats() {
    return (
        <div class="text-gray-200 body-font max-w-sm">
            <div class="container px-5 mx-auto">

                <div class="flex flex-wrap -m-4 text-center">
                
                <div class="p-4 md:w-1/3 sm:w-1/2 w-full">
                    <div class="border-2 border-gray-700 px-3 py-3 rounded-lg">

                    <h2 class="title-font font-bold text-2xl text-trillBlue">74</h2>
                    <p class="leading-relaxed">Albums</p>
                    </div>
                </div>

                <div class="p-4 md:w-1/3 sm:w-1/2 w-full">
                    <div class="border-2 border-gray-700 px-3 py-3 rounded-lg">
                    <h2 class="title-font font-bold text-2xl text-trillBlue">1.3K</h2>
                    <p class="leading-relaxed">Following</p>
                    </div>
                </div>

                <div class="p-4 md:w-1/3 sm:w-1/2 w-full">
                    <div class="border-2 border-gray-700 px-3 py-3 rounded-lg">
                    <h2 class="title-font text-2xl text-trillBlue font-bold">1.3K</h2>
                    <p class="leading-relaxed">Followers</p>
                    </div>
                </div>
            
                </div>
            </div>
        </div>
    );
}

export default UserStats