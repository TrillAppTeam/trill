function HeroSection() {
    return (
        <div className="flex flex-col items-center pb-[250px]">
            {/* Logo and Login */}
            <div className="flex flex-row justify-between absolute mx-auto w-full max-w-5xl pt-10 items-center">
                <div>
                    <img src='/trillTransparent.png' alt="Trill Logo" width="100" />
                </div>

                <div className="flex-wrap z-10">
                    <a href="https://auth.trytrill.com/login?client_id=126gi8rqrvn4rbv1kt7ef714oa&response_type=code&scope=email+openid+phone+aws.cognito.signin.user.admin&redirect_uri=https%3A%2F%2Fwww.trytrill.com%2Fhome"
                        className="font-bold text-lg md:text-2xl text-slate-100 p-5 hover:text-trillBlue">
                        LOGIN
                    </a>
                    {/* commenty comment */}
                    <a href="https://auth.trytrill.com/signup?client_id=126gi8rqrvn4rbv1kt7ef714oa&response_type=code&scope=email+openid+phone+aws.cognito.signin.user.admin&redirect_uri=https%3A%2F%2Fapi.trytrill.com%2Fmain%2Fhello"
                        className="font-bold text-lg md:text-2xl text-slate-100 p-5 hover:text-trillBlue">
                        CREATE ACCOUNT
                    </a>
                </div>
            </div>
            
            {/* Main Hero Image - Abbey Road */}
            <img className="w-auto h-[700px] mix-blend-lighten opacity-95" src='/beatles.png' alt='The Beatles' /> 

            {/* Trill Slogan */}
            <div className="items-end pt-[330px] absolute top-80 z-1">
                <h1 className="font-bold text-5xl md:text-7xl text-white"> A social network for
                    <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> music lovers.</span>
                </h1>
                <p className="italic text-2xl text-white py-5 md:text-3xl">Track albums you've listened to. Save those you want to hear. Tell your friends what's good.</p>
                <button className="font-bold text-lg bg-trillBlue rounded-lg text-trillPurple py-2 px-4 md:text-2xl hover:bg-cyan-300 ">Get Started - It's Free!</button>
            </div>
        </div>
    );
}

export default HeroSection