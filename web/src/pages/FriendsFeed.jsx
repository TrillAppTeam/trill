import { useQuery } from "@tanstack/react-query";

// Components
import Review from "../components/Review";
import Titles from "../components/Titles";
import Loading from "../components/Loading";


function FriendsFeed() {
    const { isLoading, data } = useQuery(['reviews?sort=newest&following=true']);

    return (
        <div className="max-w-6xl mx-auto">
            {isLoading ? <Loading /> : 
                <>
                    <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-10 pb-10">Discover new songs together.</h1>
                    <Titles title="Friends Feed" />
                    {data?.data.slice(0, 20).map((review, index, array) => (
                    <div key={index}>
                        <Review review={review} />
                        {index !== array.length - 1 && <div className="border-t border-gray-600 max-w-6xl mx-auto m-4" />}
                    </div>
                ))}                  
                </>
            }
            <div className="pb-20" />
        </div>
    );
}

export default FriendsFeed