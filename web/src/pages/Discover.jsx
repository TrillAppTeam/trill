import { Link } from "react-router-dom";
import { useQuery } from "@tanstack/react-query";

// Components
import Titles from "../components/Titles";
import NewsCard from "../components/NewsCard";
import Album from "../components/Album";
import Review from "../components/Review";
import Loading from "../components/Loading";
import AlbumReview from "../components/AlbumReview"

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

function Discover() {
    const { isLoading, error, data} = useQuery({ queryKey: ['users'] });

    return (
        <div>
            { isLoading ? <Loading/> : <>
            {/* Welcome Message */}
            <section>
                <h1 className="font-bold text-3xl md:text-5xl text-white text-center pt-[20px]"> Welcome back,
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> {data.data.nickname}. </span><br/>
                    <p className="italic text-white text-2xl md:text-4xl py-[15px]">Here's what the world has been listening to.</p>
                </h1>
            </section>
            
            {/* Album Discovery */}
            <section className="pt-14"> 
                <Titles title="Popular Albums This Week - Globally"/>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    <Album album = {{ img: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/2a/19/fb/2a19fb85-2f70-9e44-f2a9-82abe679b88e/886449990061.jpg/1200x1200bf-60.jpg", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/3/38/Lizzo_-_Special.png", size: "100"}} />
                    <Album album = {{ img: "https://media.pitchfork.com/photos/627c1023d3c744a67a846260/1:1/w_600/Kendrick-Lamar-Mr-Morale-And-The-Big-Steppers.jpg", size: "100"}} />
                    <Album album = {{ img: "https://media.pitchfork.com/photos/60f6cf8ec64eabe66d59ccf1/1:1/w_600/Coldplay.jpeg", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/7/7a/Brandi_Carlile_-_In_These_Silent_Days.png", size: "100"}} />
                    <Album album = {{ img: "https://m.media-amazon.com/images/I/51kK5l3-WTL._UXNaN_FMjpg_QL85_.jpg", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/thumb/a/ad/Beyonc%C3%A9_-_Renaissance.png/220px-Beyonc%C3%A9_-_Renaissance.png", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/6/60/Bad_Bunny_-_Un_Verano_Sin_Ti.png", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/7/76/Adele_-_30.png", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100"}} />
                </div>
            </section>

            <section className="pt-14"> 
                <Titles title="Popular Reviews This Week - Globally"/>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    <AlbumReview album={{ img: "https://m.media-amazon.com/images/I/51kK5l3-WTL._UXNaN_FMjpg_QL85_.jpg", size: "100", user: "dmflo", rating: 2}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/6/60/Bad_Bunny_-_Un_Verano_Sin_Ti.png", size: "100", user: "avwede", rating: 5}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "csmi", rating: 10}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/7/7a/Brandi_Carlile_-_In_These_Silent_Days.png", size: "100", user: "avwede", rating: 1}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "chian", rating: 9}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/7/76/Adele_-_30.png", size: "100", user: "avwede", rating: 2}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "prathik",rating: 10}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "chris", rating: 5}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/3/38/Lizzo_-_Special.png", size: "100", user: "avwede", rating: 10}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/7/76/Adele_-_30.png", size: "100", user: "john", rating: 8}} />
                </div>
            </section>

            <section className="pt-14"> 
                <Titles title="New From Friends"/>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "avwede", rating: 5}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/3/38/Lizzo_-_Special.png", size: "100", user: "avwede", rating: 10}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/7/76/Adele_-_30.png", size: "100", user: "jon", rating: 8}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/6/60/Bad_Bunny_-_Un_Verano_Sin_Ti.png", size: "100", user: "doe", rating: 2}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/6/60/Bad_Bunny_-_Un_Verano_Sin_Ti.png", size: "100", user: "avwede", rating: 5}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "harry", rating: 10}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/7/7a/Brandi_Carlile_-_In_These_Silent_Days.png", size: "100", user: "avwede", rating: 1}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "niall", rating: 9}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/7/76/Adele_-_30.png", size: "100", user: "avwede", rating: 2}} />
                    <AlbumReview album={{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100", user: "liam",rating: 10}} />
                </div>
            </section>

            <section className="pt-14"> 
                <Titles title="Reviews from Friends"/>
                <Review review={exampleReview}/>
                <div className="border-t border-gray-600 max-w-6xl mx-auto" />
                <Review review={anotherExample}/>
            </section>

            {/* Music News */}
            <section className="pt-14">
                <Titles title="Recent News"/>
                <NewsCard news={newsInfo}/> 
                <NewsCard news={grammyNews}/> 
            </section>

            {/* Grammy Fun! */}
            <section className="pt-14">
                <Titles title="Hello, Grammys"/>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    <Album album = {{ img: "https://is2-ssl.mzstatic.com/image/thumb/Music126/v4/2a/19/fb/2a19fb85-2f70-9e44-f2a9-82abe679b88e/886449990061.jpg/1200x1200bf-60.jpg", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/3/38/Lizzo_-_Special.png", size: "100"}} />
                    <Album album = {{ img: "https://media.pitchfork.com/photos/627c1023d3c744a67a846260/1:1/w_600/Kendrick-Lamar-Mr-Morale-And-The-Big-Steppers.jpg", size: "100"}} />
                    <Album album = {{ img: "https://media.pitchfork.com/photos/60f6cf8ec64eabe66d59ccf1/1:1/w_600/Coldplay.jpeg", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/7/7a/Brandi_Carlile_-_In_These_Silent_Days.png", size: "100"}} />
                    <Album album = {{ img: "https://m.media-amazon.com/images/I/51kK5l3-WTL._UXNaN_FMjpg_QL85_.jpg", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/thumb/a/ad/Beyonc%C3%A9_-_Renaissance.png/220px-Beyonc%C3%A9_-_Renaissance.png", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/6/60/Bad_Bunny_-_Un_Verano_Sin_Ti.png", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/7/76/Adele_-_30.png", size: "100"}} />
                    <Album album = {{ img: "https://upload.wikimedia.org/wikipedia/en/e/e0/ABBA_-_Voyage.png", size: "100"}} />
                </div>
                <p className="max-w-6xl mx-auto pt-2 pb-2">The 2023 Grammy Nominations for Album of the Year.</p>
                <p className="max-w-6xl mx-auto italic text-gray-500">WINNER: Harry's House by Harry Styles. Tyler Johnson, Kid Harpoon & Sammy Witte, producers; Jeremy Hatcher, Oli Jacobs, Nick Lobel, Spike Stent & Sammy Witte, engineers/mixers; Amy Allen, Tobias Jesso, Jr., Tyler Johnson, Kid Harpoon, Mitch Rowland, Harry Styles & Sammy Witte, songwriters; Randy Merrill, mastering engineer.</p>
            </section>

            <section className="pt-14">
                <Titles title="Trill Team Favorites"></Titles>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273c288028c2592f400dd0b9233", size: "100", name: "folklore (deluxe version)"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2737af5fdc5ef048a68db62b85f", size: "100", name: "Continuum"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2735274788f34fc7656d2856dfd", size: "100", name: "Siamese Dream (Deluxe Edition)"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2734c79d5ec52a6d0302f3add25", size: "100", name: "Ctrl"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273d58e537cea05c2156792c53d", size: "100", name: "good kid, m.A.A.d city (Deluxe)"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015", size: "100", name: "Speak Now"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b27387459a563f92e336d282ca59", size: "100", name: "Growin' Up"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b27357b7f789d328c205b4d15893", size: "100", name: "From The Fires"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273a91b75c9ef65ed8d760ff600", size: "100", name: "Punisher"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2738a162cd60b075bef224ffab7", size: "100", name: "All Things Must Pass (2014 Remaster)"}} />
                </div>
                <p className="max-w-6xl mx-auto text-gray-400 pt-2 pb-10 text-left italic">Our team's top picks.</p>
            </section>
            </>}
        </div>
    );
}

export default Discover;