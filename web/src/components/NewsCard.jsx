function NewsCard(props) {
    const { title, newsLink, imgLink, body } = props.news;

    return (
        <div className="card card-side bg-gray-700 shadow-xl max-w-6xl mx-auto mb-10">
            <figure className="w-1/3">
                <img src={imgLink} alt="Rolling Stones Article"/>
            </figure>
            <div className="card-body">
                <h2 className="card-title">{title}</h2>
                <p>{body}</p>
                <div className="card-actions justify-start">
                    <a href={newsLink} target="_blank">
                        <button className="btn btn-trillBlue" >Read More</button>
                    </a>
                </div>
            </div>
        </div>
    );
}

export default NewsCard;
