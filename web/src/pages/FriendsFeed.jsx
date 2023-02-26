import Review from "../components/Review"

let exampleReview = {
    user: "Ligma Johnson",
    profilePic: "https://www.meme-arsenal.com/memes/be23686a25bc2d9b52a04ebdf6e4f280.jpg",
    review: "For Kevin Parker, perfectionism is a lonely thing. The fastidious Tame Impala mastermind often copes with his self-isolation and doubt through stonerisms, highly portable mantras like “let it happen” and “yes I’m changing” and “gotta be above it” (said three times fast to ward off bad vibes). Their inverse is the negativity Parker’s trying to keep at bay in his head: “It feels like we only go backwards,” “But you’ll make the same old mistakes,” “You will never come close to how I feel.” It is easy to get lost in all the layers of groovy, time-traveling technicolor surround sound, particularly because Parker isn’t really trying to be clever or literary, but the internal tug of war within the Australian musician’s lyrics—between trying to better yourself and stay present, or succumbing to your own worst thoughts—is part of what keeps fans faithfully returning to Tame’s three albums, perhaps subconsciously. The repetition of phrases pairs well with the dubby, trance-like aspects of the music. Think of it as psychedelia for people with meditation apps and vape pens: Instead of opening your mind, you’re just trying to silence it.",
    rating: 5,
    albumImg: "https://upload.wikimedia.org/wikipedia/en/9/9b/Tame_Impala_-_Currents.png",
    albumName: "Currents",
    albumYear: "2020",
    artist: "Tame Impala"
}

let anotherExample = {
    user: "Jake Gyllenhal",
    profilePic: null,
    review: "john mayer does it again with his live rendition",
    rating: 10,
    albumImg: "https://m.media-amazon.com/images/I/81lfMW3-N0L._UF1000,1000_QL80_.jpg",
    albumName: "Where The Light Is",
    albumYear: "2016",
    artist: "John Mayer"
}

function FriendsFeed() {
    return (
        <div>            
            <h1 className="font-bold text-3xl md:text-4xl text-white text-center pt-[20px] pb-10">Discover new songs together.</h1>
            <Review review={exampleReview}/>
            <div className="border-t border-gray-600 max-w-6xl mx-auto" />
            <Review review={anotherExample}/>
        </div>
    );
}

export default FriendsFeed