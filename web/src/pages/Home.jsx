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
            <p>Home Page</p>
            <h1>Welcome back, {firstName}. Here's what the world has been listening to.</h1>

            
            <h1>Popular Albums This Week (Globally)</h1>
            <h1>Popular Reviews This Week (Globally)</h1>
            <h1>New From Friends</h1>
            <h1>Reviews from Friends</h1>
        </div>
    );
}

export default Home;