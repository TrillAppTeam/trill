// Components
import Album from "../components/Album"
import Titles from "../components/Titles"

function AlbumsSection() {
    return (
        <div>
            <Titles title="Hello, Grammys"></Titles>
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
            <p className="max-w-6xl mx-auto pt-2 pb-2 text-left">The 2023 Grammy Nominations for Album of the Year.</p>
            <p className="max-w-6xl mx-auto italic text-gray-500 pb-10 text-left">WINNER: Harry's House by Harry Styles. Tyler Johnson, Kid Harpoon & Sammy Witte, producers; Jeremy Hatcher, Oli Jacobs, Nick Lobel, Spike Stent & Sammy Witte, engineers/mixers; Amy Allen, Tobias Jesso, Jr., Tyler Johnson, Kid Harpoon, Mitch Rowland, Harry Styles & Sammy Witte, songwriters; Randy Merrill, mastering engineer.</p>
        </div>
    );
}

export default AlbumsSection