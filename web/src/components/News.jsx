function News() {
    return (
        <div className="card card-side bg-gray-700 shadow-xl max-w-6xl mx-auto">
        <figure className="w-2/6">
            <img src="https://www.rollingstone.com/wp-content/uploads/2022/12/RollingStone_-200-Greatest-Singers_Collage.gif" alt="Rolling Stones Article"/>
        </figure>
        <div className="card-body">
            <h2 className="card-title">The 200 Greatest Singers of All Time</h2>
            <p>From Sinatra to SZA, from R&B to salsa to alt-rock. Explore the voices of the ages.</p>
            <div className="card-actions justify-start">
                <a href="https://www.rollingstone.com/music/music-lists/best-singers-all-time-1234642307/" target="_blank">
                    <button className="btn btn-trillBlue" >Read More</button>
                </a>
            </div>
        </div>
        </div>
    );
}

export default News;