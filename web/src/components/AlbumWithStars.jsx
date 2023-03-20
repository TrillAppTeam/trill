// Components
import Stars from "./Stars"
import Album from "./Album"

function AlbumWithStars (props) {
    const { rating } = props.album.review;
    const { images, name, release_date, artists, external_urls, id } = props.album.review.album;

    const album = { 
        images,
        name,
        release_date,
        artists,
        external_urls,
        id
      };

    return(
        <div>
            <Album album={{...album, size: "150"}}/> 

            <div className="flex flex-row justify-between text-sm pt-1 text-gray-400">
                <Stars rating={rating} />
            </div>
        </div>
    );
}


export default AlbumWithStars