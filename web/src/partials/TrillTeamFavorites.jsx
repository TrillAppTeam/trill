import Titles from "../components/Titles";
import Album from "../components/Album";

function TrillTeamFavorites() {
    return (
        <div>
            <Titles title="Trill Team Favorites"></Titles>
                <div className="text-white flex flex-row justify-center gap-4 max-w-6xl mx-auto">
                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273c288028c2592f400dd0b9233"}], 
                        "name": "folklore (deluxe version)",
                        "artists": [
                            { "name": "Taylor Swift" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/1pzvBxYgT6OVwJLtHkrdQK"
                        },
                        "release_date": "2020",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2737af5fdc5ef048a68db62b85f"}], 
                        "name": "Continuum",
                        "artists": [
                            { "name": "John Mayer" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/1Xsprdt1q9rOzTic7b9zYM"
                        },
                        "release_date": "2006",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2734c79d5ec52a6d0302f3add25"}], 
                        "name": "Ctrl",
                        "artists": [
                            { "name": "SZA" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/76290XdXVF9rPzGdNRWdCh"
                        },
                        "release_date": "2017",
                        "size": "100" }} 
                    />

                    
                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2735274788f34fc7656d2856dfd"}], 
                        "name": "Siamese Dream (Deluxe Edition)",
                        "artists": [
                            { "name": "The Smashing Pumpkins" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/0bQglEvsHphrS19FGODEGo"
                        },
                        "release_date": "1993",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273d58e537cea05c2156792c53d"}], 
                        "name": "good kid, m.A.A.d city (Deluxe)",
                        "artists": [
                            { "name": "Kendrick Lamar" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/3DGQ1iZ9XKUQxAUWjfC34w"
                        },
                        "release_date": "2012",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015"}], 
                        "name": "Speak Now",
                        "artists": [
                            { "name": "Taylor Swift" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/5MfAxS5zz8MlfROjGQVXhy"
                        },
                        "release_date": "2010",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b27387459a563f92e336d282ca59"}], 
                        "name": "Growin' Up",
                        "artists": [
                            { "name": "Luke Combs" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/1m9DVgV0kEBiVZ4ElhJEte"
                        },
                        "release_date": "2022",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b27357b7f789d328c205b4d15893"}], 
                        "name": "From The Fires",
                        "artists": [
                            { "name": "Greta Van Fleet" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/6uSnHSIBGKUiW1uKQLYZ7w"
                        },
                        "release_date": "2017",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b273a91b75c9ef65ed8d760ff600"}], 
                        "name": "Punisher",
                        "artists": [
                            { "name": "Phoebe Bridgers" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/6Pp6qGEywDdofgFC1oFbSH"
                        },
                        "release_date": "2020",
                        "size": "100" }} 
                    />

                    <Album album = {{  "images": [{"url": "https://i.scdn.co/image/ab67616d0000b2738a162cd60b075bef224ffab7"}], 
                        "name": "All Things Must Pass (2014 Remaster)",
                        "artists": [
                            { "name": "George Harrison" }
                        ],
                        "external_urls": {
                            "spotify": "https://open.spotify.com/album/4RzYS74QxvpqTDVwKbhuSg"
                        },
                        "release_date": "1970",
                        "size": "100" }} 
                    />
                </div>
                <p className="max-w-6xl mx-auto text-gray-400 pt-2 pb-10 text-left italic">Our team's top picks.</p>
        </div>
    );
}

export default TrillTeamFavorites