import Stars from "../components/Stars"

function AvgReviews() {
    return (
        <div className="flex flex-col max-w-xl p-4 shadow-sm rounded-xl bg-[#383b59] text-gray-100">
            <div className="flex flex-col w-full">
                <h2 className="px-20 text-xl text-center text-gray-200 pb-4">Average Rating</h2>
                <p className="text-4xl mx-auto font-bold">9.8</p>  

                <div className="flex text-2xl mx-auto pb-1">
                    <Stars rating={10} />
                </div>
                
                <p className="text-sm italic text-gray-300 mx-auto pb-8">74 global ratings</p>

                <div className="flex flex-col">
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm text-gray-200">5 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm bg-gray-600">
                            <div className="bg-trillBlue h-4 w-5/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right text-gray-200">83%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm text-gray-200">4 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm bg-gray-600">
                            <div className="bg-trillBlue h-4 w-4/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right text-gray-200">67%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm text-gray-200">3 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm bg-gray-600">
                            <div className="bg-trillBlue h-4 w-3/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right text-gray-200">50%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm text-gray-200">2 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm bg-gray-600">
                            <div className="bg-trillBlue h-4 w-2/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right text-gray-200">33%</span>
                    </div>
                    <div className="flex items-center space-x-1">
                        <span className="flex-shrink-0 w-12 text-sm text-gray-200">1 star</span>
                        <div className="flex-1 h-4 overflow-hidden rounded-sm bg-gray-600">
                            <div className="bg-trillBlue h-4 w-1/6"></div>
                        </div>
                        <span className="flex-shrink-0 w-12 text-sm text-right text-gray-200">17%</span>
                    </div>
                </div>
            </div>

        </div>
    );
}

export default AvgReviews