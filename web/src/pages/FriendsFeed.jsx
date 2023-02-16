import Review from "../components/Review"

let exampleReview = {
    user: "Ligma Johnson",
    profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
    review: "This album altered my brain wavelengths",
    albumImg: "/currentsAlbum.jpg",
    albumName: "Currents",
    albumYear: "2020"
}

function FriendsFeed() {
    return (
        <div>            
            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-[20px]">Discover new songs together.</h1>
            <Review review={exampleReview}/>
        </div>
    );
}

export default FriendsFeed;