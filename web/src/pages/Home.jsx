const userData =
    {
        userName: "avwede",
        firstName: "Ashley",
        lastName: "Voglewede",
        email: "avwede@gmail.com"
    };


function Home() {
    const {userName, firstName, lastName, email} = userData;
    return (
        <div className="text-white">
            <h1 className="font-bold text-5xl md:text-5xl text-white text-center pt-[20px]"> Welcome back,
                <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> {firstName}. </span><br/>
                <h2 className="text-4xl md:text-4xl py-[15px]">Here's what the world has been listening to.</h2>
            </h1>

            
            <h1>Popular Albums This Week (Globally)</h1>
            <h1>Popular Reviews This Week (Globally)</h1>
            <h1>New From Friends</h1>
            <h1>Reviews from Friends</h1>
        </div>
    );
}

export default Home;