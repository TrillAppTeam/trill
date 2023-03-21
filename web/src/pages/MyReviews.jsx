//Components
import Titles from "../components/Titles";
import AlbumWithStars from "../components/AlbumWithStars";
import { useQuery } from "@tanstack/react-query";

// Components
import Loading from "../components/Loading"

function MyReviews() {
    const currentUser = sessionStorage.getItem("username");
    const { data: userData } = useQuery([`users?username=${currentUser}`]);
    const { isLoading, data: myReviews } = useQuery([`reviews?username=${currentUser}&sort=newest`]);
    const { data: myReviewsPageTwo } = useQuery([`reviews?username=${currentUser}&sort=newest&page=2`], {enabled: userData?.review_count >= 20});

    return (
        <div className="max-w-6xl mx-auto pb-10">           
            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-10 pb-10">Your musical journey, in review.</h1>

                {isLoading 
                    ?   <Loading />
                    :   <>
                        
                            { Array.isArray(myReviews) 
                                ?   <>                                        
                                        <Titles title={`You have reviewed ${userData?.review_count} albums`}/>

                                        <div className="text-white flex flex-row flex-wrap justify-left gap-4 max-w-6xl mx-auto">
                                            {myReviews.map((review) => (
                                                <AlbumWithStars album={{review}} />
                                            ))}

                                            {myReviewsPageTwo 
                                                ?  myReviewsPageTwo.map((review) => (
                                                    <AlbumWithStars album={{review}} />
                                                ))
                                                : null
                                            }

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