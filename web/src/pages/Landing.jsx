function Landing() {
    return (
        <div className="flex flex-col bg-trillPurple min-h-screen text-center">
            
            <section className="flex flex-col items-center">
                
                <div className="relative flex grow-3 justify-center items-end">
                    <img className="w-[auto] h-[700px] mix-blend-lighten opacity-90" src='/beatles.png' alt='The Beatles' /> 

                    <img className= "pt-[240px] absolute top-80 z-1" src='/trillTransparent.png' alt='Trill Logo'/>
                </div>

                <h1 className="font-bold text-7xl text-white pt-[300px]"> A social network for
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> music lovers.</span>
                </h1>
                
                <p className="italic text-2xl text-white py-5">Track albums you've listened to. Save those you want to hear. Tell your friends what's good.</p>

                <button className="font-bold text-1xl bg-trillBlue rounded-lg text-trillPurple py-2 px-4">Get Started - It's Free!</button>
            
            </section>
            
        </div>
    );
}

export default Landing;