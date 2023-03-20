//Components
import Titles from "../components/Titles";
import AlbumWithStars from "../components/AlbumWithStars";
import { useQuery } from "@tanstack/react-query";

// Components
import Loading from "../components/Loading"

function MyReviews() {
    const currentUser = sessionStorage.getItem("username");
    const { isLoading, data: myReviews } = useQuery([`reviews?username=${currentUser}&sort=newest`]);
    const { data: userData } = useQuery([`users?username=${currentUser}`]);
    const { data: myReviewsPageTwo } = useQuery([`reviews?username=${currentUser}&sort=newest&page=2`], {enabled: userData?.data?.review_count >= 20});
    const reviewsData = userData?.data?.review_count > 20 ? [...myReviews?.data, ...myReviewsPageTwo?.data] : myReviews?.data;

    return (
        <div className="max-w-6xl mx-auto pb-10">           

            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-10 pb-10">Your musical journey, in review.</h1>
                {isLoading 
                    ?   <Loading />
                    :   <>
                            { Array.isArray(myReviews?.data) 
                                ?   <>                                        
                                        <Titles title={`You have reviewed ${userData?.data.review_count} albums`}/>

                                        <div className="text-white flex flex-row flex-wrap justify-left gap-4 max-w-6xl mx-auto">
                                            {reviewsData.map((review) => (
                                                <AlbumWithStars album={{review}} />
                                            ))}

                                        </div>
                                    </>
                                :   <div>
                                        <Titles title="You have reviewed 0 albums"/>
                                        <h1 className="italic text-trillBlue">No albums reviewed yet.</h1>
                                    </div>
                            }
                        </>  
                }
        </div>
    );

}

export default MyReviews