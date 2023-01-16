import { Link } from "react-router-dom";

function Landing() {
    return (
        <div className="flex flex-col bg-trillPurple min-h-screen text-center">            
            <section className="flex flex-col items-center">
                <div className="relative flex grow-3 justify-center">

                    <div className="absolute left-10 lg:flex lg:items-center lg:w-auto items-start z-10 pt-6 pl-5">
                        <img src='/trillTransparent.png' alt="Trill Logo" width="100" />
                    </div>

                    <div className="absolute right-0 lg:flex lg:items-center lg:w-auto items-start z-10 pt-4 pr-10">
                        <Link to="Login" className="font-bold text-lg text-slate-100 p-5 hover:text-trillBlue"> LOGIN </Link>
                        <Link to="CreateAccount" className="font-bold text-lg text-slate-100 p-5 hover:text-trillBlue"> CREATE ACCOUNT </Link>
                    </div>

                    <img className="w-[auto] h-[700px] mix-blend-lighten opacity-95" src='/beatles.png' alt='The Beatles' /> 

                    <div className="items-end pt-[330px] absolute top-80 z-1">
                        <h1 className="font-bold text-7xl text-white"> A social network for
                            <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> music lovers.</span>
                        </h1>
                        <p className="italic text-3xl text-white py-5">Track albums you've listened to. Save those you want to hear. Tell your friends what's good.</p>
                        <button className="font-bold text-2xl bg-trillBlue rounded-lg text-trillPurple py-2 px-4">Get Started - It's Free!</button>
                    </div>

                </div>
            </section>
            
        </div>
    );
}

export default Landing;