// Components
import Titles from "../components/Titles"
import Album from "../components/Album"

function HelloGrammys() {
    return(
        <div>
            <Titles title="Hello, Grammys"/>
            <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0"}], 
                    "name": "Harry's House",
                    "artists": [
                        { "name": "Harry Styles" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/5r36AJ6VOJtp00oxSkBZ5h"
                    },
                    "release_date": "2022",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273fe3b1b9cb7183a94e1aafd43"}], 
                    "name": "Special",
                    "artists": [
                        { "name": "Lizzo" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/1NgFBv1PxMG1zhFDW1OrRr"
                    },
                    "release_date": "2022",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2732e02117d76426a08ac7c174f"}], 
                    "name": "Mr. Morale & The Big Steppers",
                    "artists": [
                        { "name": "Kendrick Lamar" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/79ONNoS4M9tfIA1mYLBYVX"
                    },
                    "release_date": "2022",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273ec10f247b100da1ce0d80b6d"}], 
                    "name": "Music Of The Spheres",
                    "artists": [
                        { "name": "Coldplay" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/06mXfvDsRZNfnsGZvX2zpb"
                    },
                    "release_date": "2021",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b27335bd3c588974a8c239e5de87"}], 
                    "name": "In These Silent Days",
                    "artists": [
                        { "name": "Brandi Carlile" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/5mIT7iw9w64DMP2vxP9L1f"
                    },
                    "release_date": "2021",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b27363b9d8845fe7d34795c16c9d"}], 
                    "name": "Good Morning Gorgeous (Deluxe)",
                    "artists": [
                        { "name": "Mary J. Blige" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/5K3aBzXwBvSltrtfBNYRl6"
                    },
                    "release_date": "2022",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7"}], 
                    "name": "RENAISSANCE",
                    "artists": [
                        { "name": "Beyoncé" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/6FJxoadUE4JNVwWHghBwnb"
                    },
                    "release_date": "2022",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b27349d694203245f241a1bcaa72"}], 
                    "name": "Un Verano Sin Ti",
                    "artists": [
                        { "name": "Bad Bunny" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/3RQQmkQEvNCY4prGKE6oc5"
                    },
                    "release_date": "2022",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273c6b577e4c4a6d326354a89f7"}], 
                    "name": "30",
                    "artists": [
                        { "name": "Adele" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/21jF5jlMtzo94wbxmJ18aa"
                    },
                    "release_date": "2021",
                    "size": "100" }} 
                />

                <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273225d9c1b06ca69aec9b08381"}], 
                    "name": "Voyage",
                    "artists": [
                        { "name": "ABBA" }
                    ],
                    "external_urls": {
                        "spotify": "https://open.spotify.com/album/0uUtGVj0y9FjfKful7cABY"
                    },
                    "release_date": "2021",
                    "size": "100" }} 
                />

            </div>
            <p className="max-w-6xl mx-auto pt-2 pb-2 text-left">The 2023 Grammy Nominations for Album of the Year.</p>
            <p className="max-w-6xl mx-auto italic text-gray-500 text-left">WINNER: Harry's House by Harry Styles. Tyler Johnson, Kid Harpoon & Sammy Witte, producers; Jeremy Hatcher, Oli Jacobs, Nick Lobel, Spike Stent & Sammy Witte, engineers/mixers; Amy Allen, Tobias Jesso, Jr., Tyler Johnson, Kid Harpoon, Mitch Rowland, Harry Styles & Sammy Witte, songwriters; Randy Merrill, mastering engineer.</p>
        </div>
    );
}

export default HelloGrammys