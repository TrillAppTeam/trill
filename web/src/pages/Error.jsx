import { useRouteError } from "react-router-dom";
import { Link } from "react-router-dom";

import TrillLogo from "/trillCircle.png"


function Error() {
    const error = useRouteError();
    console.error(error);

    return (
        <div className="min-w-screen min-h-screen bg-trillPurple flex items-center p-5 lg:p-20 overflow-hidden relative">
       
        <div className="z-10 flex-1 min-h-full min-w-full rounded-3xl bg-white shadow-xl p-10 lg:p-20 text-gray-800 relative md:flex items-center text-center md:text-left">
            <div className="w-full md:w-1/2">
                <div className="mb-10 md:mb-20 text-gray-600 font-light">
                    <h1 className="font-black uppercase text-3xl lg:text-8xl text-black mb-10">404 Error</h1>
                    <h1 className="font-black uppercase text-3xl lg:text-5xl text-trillBlue mb-10">You seem to be lost!</h1>
                    <h2 className="font-black text-2xl lg:text-3xl text-gray-400 mb-10">An error has occurred.</h2>
                </div>
                <div className="mb-20 md:mb-0">
                    {/* TO DO: Update once routing is fixed */}
                    <Link to="User/Home">
                        <button className="text-lg font-light outline-none focus:outline-none transform transition-all bg-gray-300 rounded p-3 hover:scale-110 text-black hover:text-trillBlue">
                            Return to Home
                        </button>
                    </Link>
                </div>
            </div>

            <div className="w-full md:w-1/2 text-center">
                <img src={TrillLogo} className="z-10 w-full max-w-lg lg:max-w-full mx-auto"></img>
            </div>
        </div>

        <div className="z-0 w-64 md:w-96 h-96 md:h-full bg-blue-200 bg-opacity-30 absolute -top-64 md:-top-96 right-20 md:right-32 rounded-full pointer-events-none -rotate-45 transform"></div>
        <div className="z-0 w-96 h-full bg-trillBlue bg-opacity-20 absolute -bottom-96 right-64 rounded-full pointer-events-none -rotate-45 transform"></div>
    </div>
    );
}

export default Error;