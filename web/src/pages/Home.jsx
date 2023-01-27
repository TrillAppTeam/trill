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

// const newsInfo2 = {
//     title: "The 100 Best Albums of 2022", 
//     body: "Beyoncé's dance-music ecstasy, Bad Bunny's latest world-conquering smash, Taylor Swift's late nights, Harry Styles' song cycle, and Pusha T's master class in metaphor were only some of the albums that ruled our world this year.",
//     newsLink: "https://www.rollingstone.com/music/music-lists/best-albums-2022-list-1234632387/", 
//     imgLink: "https://www.rollingstone.com/wp-content/uploads/2022/11/RS-EOY-Lists-1.jpg?w=1581&h=1054&crop=1", 
// }

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
                <NewsCard news={newsInfo}/>
                {/* <NewsCard news={newsInfo2}/>

                <div className="carousel w-full">
                    <div id="slide1" className="carousel-item relative w-full">
                        <img src="https://placeimg.com/800/200/arch" className="w-full" />
                        <div className="absolute flex justify-between transform -translate-y-1/2 left-5 right-5 top-1/2">
                        
                        <a href="#slide4" className="btn btn-circle">❮</a> 
                        <a href="#slide2" className="btn btn-circle">❯</a>
                        </div>
                    </div> 
                    <div id="slide2" className="carousel-item relative w-full">
                        <img src="https://placeimg.com/800/200/arch" className="w-full" />
                        <div className="absolute flex justify-between transform -translate-y-1/2 left-5 right-5 top-1/2">
                        <a href="#slide1" className="btn btn-circle">❮</a> 
                        <a href="#slide3" className="btn btn-circle">❯</a>
                        </div>
                    </div> 
                    <div id="slide3" className="carousel-item relative w-full">
                        <img src="https://placeimg.com/800/200/arch" className="w-full" />
                        <div className="absolute flex justify-between transform -translate-y-1/2 left-5 right-5 top-1/2">
                        <a href="#slide2" className="btn btn-circle">❮</a> 
                        <a href="#slide4" className="btn btn-circle">❯</a>
                        </div>
                    </div> 
                    <div id="slide4" className="carousel-item relative w-full">
                        <img src="https://placeimg.com/800/200/arch" className="w-full" />
                        <div className="absolute flex justify-between transform -translate-y-1/2 left-5 right-5 top-1/2">
                        <a href="#slide3" className="btn btn-circle">❮</a> 
                        <a href="#slide1" className="btn btn-circle">❯</a>
                        </div>
                    </div>
                </div> */}
                
            </section>

        </div>
    );
}

export default Home;