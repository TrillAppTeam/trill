import Album from "../components/Album"

function AlbumsSection() {
    return (
        <div className="text-white flex flex-row justify-center gap-8 m-[10px] pb-[100px] 0">
            <Album album="/blondAlbum.jpg" />
            <Album album="/allThingsMustPassAlbum.jpg" />
            <Album album="/currentsAlbum.jpg" />
            <Album album="/whereTheLightIsAlbum.jpg" />
            <Album album="/frontiersAlbum.jpg" />
        </div>
    );
}

export default AlbumsSection