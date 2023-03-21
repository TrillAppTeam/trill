import { useQuery } from "@tanstack/react-query"

// Components
import Titles from "../components/Titles"
import NewsCard from "../components/NewsCard"
import Album from "../components/Album"
import Review from "../components/Review"
import Loading from "../components/Loading"
import NoTextAlbumReview from "../components/NoTextAlbumReview"

// Partials
import HelloGrammys from "../partials/HelloGrammys"
import TrillTeamFavorites from "../partials/TrillTeamFavorites"

const newsInfo = {
    title: "The 200 Greatest Singers of All Time", 
    body: "From Sinatra to SZA, from R&B to salsa to alt-rock. Explore the voices of the ages.",
    newsLink: "https://www.rollingstone.com/music/music-lists/best-singers-all-time-1234642307/", 
    imgLink: "https://www.rollingstone.com/wp-content/uploads/2022/12/RollingStone_-200-Greatest-Singers_Collage.gif", 
}

const grammyNews = {
    title: "2023 GRAMMY Nominations: See The Complete Winners & Nominees List", 
    body: "Read the complete list of winners and nominees across all 91 categories at the 2023 GRAMMYs here.",
    newsLink: "https://www.grammy.com/news/2023-grammy-nominations-complete-winners-nominees-list", 
    imgLink: "https://i8.amplience.net/i/naras/2023-grammy-nominations-main-key-art.jpg?w=821&sm=c", 
}

function Discover() {
    const { isLoading, data } = useQuery({ queryKey: ['users'] });
    const { isLoading: friendsDataLoading, data: friendsData } = useQuery(['reviews?sort=newest&following=true']);
    const { isLoading: popularGlobalWeeklyLoading, data: popularGlobalWeeklyData, error: popularGlobalWeeklyError } = useQuery([`albums?timespan=weekly`]);
    const { isLoading: popularGlobalAllTimeLoading, data: popularGlobalAllTimeData, error: popularGlobalAllTimeError } = useQuery([`albums?timespan=all`]);

    return (
        <div>
            { isLoading ? <Loading/> : <>
            {/* Welcome Message */}
            <section>
                <h1 className="font-bold text-3xl md:text-5xl text-white text-center pt-[20px]"> Welcome back,
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> {data?.data.nickname}. </span><br/>
                    <p className="italic text-white text-2xl md:text-4xl py-[15px]">Here's what the world has been listening to.</p>
                </h1>
            </section>
            
            {/* Album Discovery */}
            <section className="pt-14"> 
                <Titles title="Popular Albums This Week - Globally"/>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    {popularGlobalWeeklyLoading
                        ? "Loading..."  
                        : popularGlobalWeeklyData?.data?.map((album) => (
                            <div key={album.id}>
                                <Album album={album} />
                            </div>
                        ))
                    }
                </div>
            </section>

            <section className="pt-14"> 
                <Titles title="New From Friends"/>
                <div className="text-white flex flex-row justify-left gap-5 max-w-6xl mx-auto">
                    {friendsDataLoading ? "Loading..." :  
                        friendsData?.data.slice(0, 10).map((review) => (
                            <div key={review.review_id}>
                                <NoTextAlbumReview review={review} />
                            </div>
                        ))
                    }
                </div>
            </section>

            <section className="pt-14"> 
                <Titles title="Reviews from Friends"/>
                <div  className="text-white max-w-6xl mx-auto">
                    {friendsDataLoading ? "Loading..." :  
                        friendsData?.data.slice(0, 2).map((review, index, array) => (
                            <div key={review.review_id}>
                                <Review review={review} />
                                {array.length > 1 && index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                            </div>
                        ))
                    }
                </div>
               
            </section>

            <section className="pt-14"> 
                <Titles title="Popular Albums All Time - Globally"/>
                <div className="text-white flex flex-row justify-left gap-4 max-w-6xl mx-auto">
                    {popularGlobalAllTimeLoading? "Loading..."  
                        : popularGlobalAllTimeData?.data?.map((album) => (
                            <Album album={album} />
                        ))
                    }
                </div>
            </section>

            {/* Music News */}
            <section className="pt-14">
                <Titles title="Recent News"/>
                <NewsCard news={newsInfo}/> 
                <NewsCard news={grammyNews}/> 
            </section>

            {/* Grammy Fun! */}
            <section className="pt-14">
                <HelloGrammys />
            </section>

            <section className="pt-14">
                <TrillTeamFavorites />
            </section>

            </>}
        </div>
    );
}

export default Discover;