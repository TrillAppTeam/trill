// Components
import Album from "../components/Album"
import Titles from "../components/Titles"

function AlbumsSection() {
    return (
        <div>
            <Titles title="Hello, Grammys"></Titles>
            <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0", size: "100", name: "Harry's House"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273fe3b1b9cb7183a94e1aafd43", size: "100", name: "Special"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2732e02117d76426a08ac7c174f", size: "100", name: "Mr. Morale & The Big Steppers"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273ec10f247b100da1ce0d80b6d", size: "100", name: "Music Of The Spheres"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b27335bd3c588974a8c239e5de87", size: "100", name: "In These Silent Days"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b27363b9d8845fe7d34795c16c9d", size: "100", name: "Good Morning Gorgeous (Deluxe)"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7", size: "100", name: "RENAISSANCE"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b27349d694203245f241a1bcaa72", size: "100", name: "Un Verano Sin Ti"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273c6b577e4c4a6d326354a89f7", size: "100", name: "30"}} />
                    <Album album = {{ img: "https://i.scdn.co/image/ab67616d0000b273225d9c1b06ca69aec9b08381", size: "100", name: "Voyage"}} />
            </div>
            <p className="max-w-6xl mx-auto pt-2 pb-2 text-left">The 2023 Grammy Nominations for Album of the Year.</p>
            <p className="max-w-6xl mx-auto italic text-gray-500 pb-10 text-left">WINNER: Harry's House by Harry Styles. Tyler Johnson, Kid Harpoon & Sammy Witte, producers; Jeremy Hatcher, Oli Jacobs, Nick Lobel, Spike Stent & Sammy Witte, engineers/mixers; Amy Allen, Tobias Jesso, Jr., Tyler Johnson, Kid Harpoon, Mitch Rowland, Harry Styles & Sammy Witte, songwriters; Randy Merrill, mastering engineer.</p>
        </div>
    );
}

export default AlbumsSection