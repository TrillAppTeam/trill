function Landing() {
    return (
        <div className="flex flex-col bg-trillPurple min-h-screen text-center">
            
            <section className="flex flex-col items-center">
                <div className="relative">
                    <img className="w-full absolute rounded-lg" src='/beatles.jpg' alt='The Beatles' /> 
                    <img className="relative mt-32" src='/trillTransparent.png' alt='Trill Logo'/>
                </div>

                <h1 className="font-bold text-7xl text-white pt-10"> A social network for
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> music lovers</span>
                </h1>
                
                <p className="italic text-2xl text-white py-5">Track albums you've listened to. Save those you want to hear. Tell your friends what's good.</p>

                <button className="font-bold text-xl bg-trillBlue rounded-lg text-trillPurple py-2 px-4">Get Started - It's Free!</button>
            </section>
        </div>
    );
}

export default Landing;