import { Link } from "react-router-dom";

function Landing() {
    return (
        <div className="bg-trillPurple min-h-screen text-center">           

            {/* Hero Section  */}
            <section className="flex flex-col items-center pb-[250px]">
                <div className="relative grow-3 justify-center">

                    <div className="absolute left-10 lg:flex lg:items-center lg:w-auto items-start z-10 pt-6 pl-5">
                        <img src='/trillTransparent.png' alt="Trill Logo" width="100" />
                    </div>

                    <div className="absolute right-0 lg:flex lg:items-center lg:w-auto items-start z-10 pt-6 pr-10">
                        <Link to="Login" className="font-bold text-lg text-slate-100 p-5 hover:text-trillBlue"> LOGIN </Link>
                        <Link to="CreateAccount" className="font-bold text-lg text-slate-100 p-5 hover:text-trillBlue"> CREATE ACCOUNT </Link>
                    </div>

                    <img className="w-[auto] h-[700px] mix-blend-lighten opacity-95" src='/beatles.png' alt='The Beatles' /> 

                    <div className="items-end pt-[330px] absolute top-80 z-1">
                        <h1 className="font-bold text-5xl md:text-7xl text-white"> A social network for
                            <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> music lovers.</span>
                        </h1>
                        <p className="italic text-2xl text-white py-5 md:text-3xl">Track albums you've listened to. Save those you want to hear. Tell your friends what's good.</p>
                        <button className="font-bold text-lg bg-trillBlue rounded-lg text-trillPurple py-2 px-4 md:text-2xl">Get Started - It's Free!</button>
                    </div>

                </div>
            </section>

            {/* Albums Section */}
            <section>
                <div className="text-white flex flex-row justify-center gap-8 m-[10px] pb-[100px]">
                    <div className="ring-2 ring-gray-500"><img src="/blondAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500"><img src="/allThingsMustPassAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500"><img src="/currentsAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500"><img src="/whereTheLightIsAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500"><img src="/frontiersAlbum.jpg" width="210
                    "/></div>
                </div>
            </section>

            {/* Features Section */}
            <section>

                <div className="max-w-6xl mx-auto text-center pb-12 md:pb-20">
                    <h2 className="italic font-bold text-xl md:text-4xl text-gray-200 pb-10">Explore Trill's Features</h2>
        
                    <div className="max-w-sm mx-auto grid gap-6 md:grid-cols-3 lg:grid-cols-4 items-start md:max-w-2xl lg:max-w-none text-white">

                        {/* Discover New Music */}
                        <div className="relative flex flex-col items-center p-6 bg-slate-700 rounded shadow-xl">
                            <svg className="w-16 h-16 p-1 -mt-1 mb-2" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
                                <g fill="none" fillRule="evenodd">
                                <rect className="fill-current text-trillBlue" width="64" height="64" rx="32" />
                                <g strokeWidth="2" transform="translate(19.429 20.571)">
                                    <circle className="stroke-current" strokeLinecap="square" cx="12.571" cy="12.571" r="1.143" />
                                    <path className="stroke-current" d="M19.153 23.267c3.59-2.213 5.99-6.169 5.99-10.696C25.143 5.63 19.514 0 12.57 0 5.63 0 0 5.629 0 12.571c0 4.527 2.4 8.483 5.99 10.696" />
                                    <path className="stroke-current" d="M16.161 18.406a6.848 6.848 0 003.268-5.835 6.857 6.857 0 00-6.858-6.857 6.857 6.857 0 00-6.857 6.857 6.848 6.848 0 003.268 5.835" />
                                </g>
                                </g>
                            </svg>
                            <h4 className="text-xl font-bold leading-snug tracking-tight mb-1">Discover New Music</h4>
                            <p className="italic text-center">Find out what albums are trending each week</p>
                        </div>

                         {/* Rate and Review */}
                        <div className="relative flex flex-col items-center p-6 bg-slate-700 rounded shadow-xl">
                            <svg className="w-16 h-16 p-1 -mt-1 mb-2" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
                                <g fill="none" fillRule="evenodd">
                                <rect className="fill-current text-trillBlue" width="64" height="64" rx="32" />
                                <g transform="translate(22.857 19.429)" strokeWidth="2">
                                    <path className="stroke-current " strokeLinecap="square" d="M12.571 4.571V0H0v25.143h12.571V20.57" />
                                    <path className="stroke-current " d="M16 12.571h8" />
                                    <path className="stroke-current " strokeLinecap="square" d="M19.429 8L24 12.571l-4.571 4.572" />
                                    <circle className="stroke-current " strokeLinecap="square" cx="12.571" cy="12.571" r="3.429" />
                                </g>
                                </g>
                            </svg>              
                            <h4 className="text-xl font-bold leading-snug tracking-tight mb-1">Rate and Review</h4>
                            <p className="italic text-center">Rate each album on a five-star scale to record your review</p>
                        </div>

                        {/* Follow Friends */}
                        <div className="relative flex flex-col items-center p-6 bg-slate-700 rounded shadow-xl">
                            <svg className="w-16 h-16 p-1 -mt-1 mb-2" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
                                <g fill="none" fillRule="evenodd">
                                <rect className="fill-current text-trillBlue" width="64" height="64" rx="32" />
                                <g strokeLinecap="square" strokeWidth="2">
                                    <path className="stroke-current " d="M38.826 22.504a9.128 9.128 0 00-13.291-.398M35.403 25.546a4.543 4.543 0 00-6.635-.207" />
                                    <path className="stroke-current " d="M19.429 25.143A6.857 6.857 0 0126.286 32v1.189L28 37.143l-1.714.571V40A2.286 2.286 0 0124 42.286h-2.286v2.285M44.571 25.143A6.857 6.857 0 0037.714 32v1.189L36 37.143l1.714.571V40A2.286 2.286 0 0040 42.286h2.286v2.285" />
                                </g>
                                </g>
                            </svg>
                            <h4 className="text-xl font-bold leading-snug tracking-tight mb-1">Follow Friends</h4>
                            <p className="italic text-center">Stay up to date with what your friends are listening to</p>
                        </div>

                        {/* Listen Later */}
                        <div className="relative flex flex-col items-center p-6 bg-slate-700 rounded shadow-xl">
                            <svg className="w-16 h-16 p-1 -mt-1 mb-2" viewBox="0 0 64 64" xmlns="http://www.w3.org/2000/svg">
                                <g fill="none" fillRule="evenodd">
                                <rect className="fill-current text-trillBlue" width="64" height="64" rx="32" />
                                <g strokeLinecap="square" strokeWidth="2">
                                    <path className="stroke-current " d="M20.571 20.571h13.714v17.143H20.571z" />
                                    <path className="stroke-current " d="M38.858 26.993l6.397 1.73-4.473 16.549-13.24-3.58" />
                                </g>
                                </g>
                            </svg>
                            <h4 className="text-xl font-bold leading-snug tracking-tight mb-1">Listen Later</h4>
                            <p className="italic text-center">Compile a list of albums you want to listen to</p>
                        </div>


                    </div>
                </div>
            </section>
        </div>
    );
}

export default Landing;