// type SpotifyAlbums struct {
// 	AlbumType    string `json:"album_type"`
// 	ExternalUrls struct {
// 		Spotify string `json:"spotify"`
// 	} `json:"external_urls"`
// 	Href   string `json:"href"`
// 	ID     string `json:"id"`
// 	Images []struct {
// 		URL    string `json:"url"`
// 		Height int    `json:"height"`
// 		Width  int    `json:"width"`
// 	} `json:"images"`
// 	Name        string   `json:"name"`
// 	ReleaseDate string   `json:"release_date"`
// 	Type        string   `json:"type"`
// 	URI         string   `json:"uri"`
// 	Genres      []string `json:"genres"`
// 	Label       string   `json:"label"`
// 	Popularity  int      `json:"popularity"`
// 	Artists     []struct {
// 		ID   string `json:"id"`
// 		Name string `json:"name"`
// 		Type string `json:"type"`
// 		URI  string `json:"uri"`
// 	} `json:"artists"`
// }

let exampleAlbum = {
    "total_tracks": 9,
    "id": "2up3OPMp9Tb4dAKM2erWXQ",
    "images": [
        {
        "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
        "height": 300,
        "width": 300
        }
    ],
    "name": "Spotify Album Example",
    "release_date": "1981-12",
    "genres": [
        "Egg punk",
        "Noise rock"
    ],
    "artists": [
        {
            "external_urls": {
            "spotify": "string"
            },
            "followers": {
            "href": "string",
            "total": 0
            },
            "genres": [
            "Prog rock",
            "Grunge"
            ],
            "href": "string",
            "id": "string",
            "images": [
            {
                "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
                "height": 300,
                "width": 300
            }
            ],
            "name": "string",
            "popularity": 0,
            "type": "artist",
            "uri": "string"
        }
    ],
}

function AlbumDetails() {
    return (

    );
    
}

export default AlbumDetails