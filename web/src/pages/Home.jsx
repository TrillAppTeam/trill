import Titles from "../components/Titles";

const userData = {
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
                <p className="text-4xl md:text-4xl py-[15px]">Here's what the world has been listening to.</p>
            </h1>

        <Titles title="Popular Albums This Week - Globally"/>
        <Titles title="Popular Reviews This Week - Globally"/>
        <Titles title="New From Friends"/>
        <Titles title="Reviews from Friends"/>
        </div>
    );
}

export default Home;