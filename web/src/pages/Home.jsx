import Titles from "../components/Titles";
import NewsCard from "../components/News";

const userData = {
    userName: "avwede",
    firstName: "Ashley",
    lastName: "Voglewede",
    email: "avwede@gmail.com"
};


function Home() {
    const {userName, firstName, lastName, email} = userData;
    return (
        <div>
            {/* Welcome Message */}
            <section>
                <h1 className="font-bold text-3xl md:text-5xl text-white text-center pt-[20px]"> Welcome back,
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> {firstName}. </span><br/>
                    <p className="italic text-white text-2xl md:text-4xl py-[15px]">Here's what the world has been listening to.</p>
                </h1>
            </section>
            
            {/* Album Discovery */}
            <section> 
                <Titles title="Popular Albums This Week - Globally"/>
                <Titles title="Popular Reviews This Week - Globally"/>
                <Titles title="New From Friends"/>
                <Titles title="Reviews from Friends"/>
            </section>

            {/* Music News */}
            <section>
                <Titles title="News"/>
                <NewsCard />
            </section>

        </div>
    );
}

export default Home;