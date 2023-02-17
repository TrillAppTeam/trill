import Stars from "../components/Stars"

function AvgReviews() {
    return (
        <div className="flex flex-col max-w-sm p-5 shadow-sm rounded-xl bg-gray-600 text-gray-100 mx-auto">
            <div className="flex flex-col w-full">
                <h2 className="text-2xl font-bold text-center px-14">Average Ratings</h2>

                {/* Average Stars out of 5 */}
                <div className="flex text-2xl mx-auto">
                    <Stars rating={5} />
                </div>

                <p className="text-md italic text-gray-400 mx-auto">74 Albums Rated</p>

                <div className="flex flex-col mt-2">
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm">5 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm dark:bg-gray-700">
                            <div className="bg-trillBlue h-4 w-5/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right">83%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm">4 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm dark:bg-gray-700">
                            <div className="bg-trillBlue h-4 w-4/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right">67%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm">3 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm dark:bg-gray-700">
                            <div className="bg-trillBlue h-4 w-3/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right">50%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm">2 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm dark:bg-gray-700">
                            <div className="bg-trillBlue h-4 w-2/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right">33%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm">1 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm dark:bg-gray-700">
                            <div className="bg-trillBlue h-4 w-1/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right">17%</span>
                    </div>
                </div>
            </div>

        </div>
    );
}

export default AvgReviews