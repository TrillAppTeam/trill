import Album from "../components/Album"

function AlbumsSection() {
    return (
        <div className="text-white flex flex-row justify-center gap-8 m-[10px] pb-[100px] 0">
            <Album album = {{ img: "/blondAlbum.jpg", size: "200"}} />
            <Album album = {{ img: "/allThingsMustPassAlbum.jpg", size: "200"}} />
            <Album album = {{ img: "/currentsAlbum.jpg", size: "200"}} />
            <Album album = {{ img: "/whereTheLightIsAlbum.jpg", size: "200"}} />
            <Album album = {{ img: "/frontiersAlbum.jpg", size: "200"}} />
            <Album album = {{ img: "/blondAlbum.jpg", size: "200"}} />
        </div>
    );
}

export default AlbumsSection