import { Link } from "react-router-dom";
import Titles from "../components/Titles";
import NewsCard from "../components/NewsCard";


const userData = {
    userName: "avwede",
    firstName: "Ashley",
    lastName: "Voglewede",
    email: "avwede@gmail.com"
};

const newsInfo = {
    title: "The 200 Greatest Singers of All Time", 
    body: "From Sinatra to SZA, from R&B to salsa to alt-rock. Explore the voices of the ages.",
    newsLink: "https://www.rollingstone.com/music/music-lists/best-singers-all-time-1234642307/", 
    imgLink: "https://www.rollingstone.com/wp-content/uploads/2022/12/RollingStone_-200-Greatest-Singers_Collage.gif", 
}

function Discover() {
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
                <NewsCard news={newsInfo}/> 
            </section>

        </div>
    );
}

export default Discover;