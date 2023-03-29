//Components
import Titles from "../components/Titles";
import Album from "../components/Album";
import { useQuery } from "@tanstack/react-query";

// Components
import Loading from "../components/Loading"

function ListenLater() {
    const currentUser = sessionStorage.getItem("username");
    const { isLoading, data: listenLater } = useQuery([`listenlateralbums?username=${currentUser}`]);

    return (
        <div className="max-w-6xl mx-auto">           

            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-10 pb-10">Don't miss a beat. Save it for later.</h1>
                {isLoading 
                    ?   <Loading />
                    :   <>
                            { Array.isArray(listenLater) 
                                ?   <>                                        
                                        <Titles title={`You want to listen to ${listenLater?.length} albums`}/>

                                        <div className="text-white flex flex-row flex-wrap justify-left gap-4 max-w-6xl mx-auto">
                                            {listenLater.map((listenLater) => (
                                                <Album album={{...listenLater, size: "130"}} />
                                            ))}
                                        </div>
                                    </>
                                :   <div>
                                        <Titles title="You want to listen to 0 albums"/>
                                        <h1 className="italic text-trillBlue">No albums in listen later.</h1>
                                    </div>
                            }
                        </>  
                }
        </div>
    );
}

export default ListenLater;