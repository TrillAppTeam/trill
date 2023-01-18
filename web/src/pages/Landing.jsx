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

            <section>
                <div className="text-white flex flex-row justify-center gap-8 m-[10px]">
                    <div className="ring-2 ring-gray-300"><img src="/blondAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-300"><img src="/allThingsMustPassAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-300"><img src="/currentsAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-300"><img src="/whereTheLightIsAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-300"><img src="/frontiersAlbum.jpg" width="210
                    "/></div>
                </div>

            </section>

        </div>
    );
}

export default Landing;