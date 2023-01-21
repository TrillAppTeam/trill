import { Link } from "react-router-dom"
import React, { useEffect, useRef, useState } from 'react'

// Components and Utils
import Transition from '../utils/Transition'
import ClickableCard from "../components/ClickableCard"
import Footer from "../components/Footer"

// Material UI Icons
import PeopleIcon from '@mui/icons-material/People'
import HearingIcon from '@mui/icons-material/Hearing'
import LibraryMusicIcon from '@mui/icons-material/LibraryMusic'
import StarRateIcon from '@mui/icons-material/StarRate'

function Landing() {
    const [tab, setTab] = useState(1)
    const tabs = useRef(null)

    const heightFix = () => {
        if (tabs.current.children[tab]) {
          tabs.current.style.height = tabs.current.children[tab - 1].offsetHeight + 'px'
        }
      }
    
      useEffect(() => {
        heightFix()
      }, [tab])

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

                    {/* Main Hero Image - Abbey Road */}
                    <img className="w-[auto] h-[700px] mix-blend-lighten opacity-95" src='/beatles.png' alt='The Beatles' /> 

                    {/* Trill Slogan */}
                    <div className="items-end pt-[330px] absolute top-80 z-1">
                        <h1 className="font-bold text-5xl md:text-7xl text-white"> A social network for
                            <span className="bg-clip-text text-transparent bg-gradient-to-r from-blue-400 to-teal-300"> music lovers.</span>
                        </h1>
                        <p className="italic text-2xl text-white py-5 md:text-3xl">Track albums you've listened to. Save those you want to hear. Tell your friends what's good.</p>
                        <button className="font-bold text-lg bg-trillBlue rounded-lg text-trillPurple py-2 px-4 md:text-2xl hover:bg-cyan-300 ">Get Started - It's Free!</button>
                    </div>
                </div>
            </section>

            {/* Albums Section */}
            <section>
                <div className="text-white flex flex-row justify-center gap-8 m-[10px] pb-[100px] 0">
                    <div className="ring-2 ring-gray-500 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110" data-aos="fade-up"><img src="/blondAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110"><img src="/allThingsMustPassAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110"><img src="/currentsAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110"><img src="/whereTheLightIsAlbum.jpg" width="210" /></div>
                    <div className="ring-2 ring-gray-500 transition ease-in-out delay-150 hover:-translate-y-1 hover:scale-110"><img src="/frontiersAlbum.jpg" width="210
                    "/></div>
                </div>
            </section>

            {/* Features Section */}
            <section>
                <div className="relative mx-auto px-4 sm:px-6 mb-8">
                    <h1 className="p-10 italic font-bold text-xl md:text-4xl text-gray-200 pb-10">Explore Trill's Features</h1>

                    <div className="w-full  min-w-48">
                        <div className="md:grid md:grid-cols-12 md:gap-6 max-w-6xl mx-auto">

                        {/* Content */}
                        <div className="max-w-xl md:max-w-none md:w-full mx-auto md:col-span-7 lg:col-span-6" data-aos="fade-right">
                            <div className="mb-8 md:mb-0">
                                <a
                                    className={`flex items-center text-lg p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 1 ? 'bg-white shadow-md border-gray-200 hover:shadow-lg' : 'bg-gray-300 border-transparent'}`}
                                    href="#0"
                                    onClick={(e) => { e.preventDefault(); setTab(1) }}
                                >
                                    <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                        <div>Discover New Music</div>
                                        <LibraryMusicIcon />
                                    </div>
                                </a>
                                <a
                                    className={`flex items-center text-lg p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 2 ? 'bg-white shadow-md border-gray-200 hover:shadow-lg' : 'bg-gray-300 border-transparent'}`}
                                    href="#0"
                                    onClick={(e) => { e.preventDefault(); setTab(2) }}
                                >
                                    <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                        <div>Rate and Review</div>
                                        <StarRateIcon />
                                    </div>
                                </a>
                                <a
                                    className={`flex items-center text-lg p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 3 ? 'bg-white shadow-md border-gray-200 hover:shadow-lg' : 'bg-gray-300 border-transparent'}`}
                                    href="#0"
                                    onClick={(e) => { e.preventDefault(); setTab(3) }}
                                >
                                    <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                        <div>Follow Friends</div>
                                        <PeopleIcon />
                                    </div>
                                </a>
                                <a
                                    className={`flex items-center text-lg p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 4 ? 'bg-white shadow-md border-gray-200 hover:shadow-lg' : 'bg-gray-300 border-transparent'}`}
                                    href="#0"
                                    onClick={(e) => { e.preventDefault(); setTab(4) }}
                                >
                                    <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                        <div>Listen Later</div>
                                        <HearingIcon />
                                    </div>
                                </a>
                            </div>
                        </div>

                        {/* Tabs items */}
                        <div className="max-w-xl md:max-w-none md:w-full mx-auto md:col-span-5 lg:col-span-6 mb-8 md:mb-0 md:order-1" data-aos="zoom-y-out" ref={tabs}>
                            <div className="relative flex flex-col text-center lg:text-right h-full">

                                {/* Item 1 */}
                                <Transition
                                    show={tab === 1}
                                    appear={true}
                                    className="w-full h-full"
                                    enter="transition ease-in-out duration-700 transform order-first"
                                    enterStart="opacity-0 translate-y-16"
                                    enterEnd="opacity-100 translate-y-0"
                                    leave="transition ease-in-out duration-300 transform absolute"
                                    leaveStart="opacity-100 translate-y-0"
                                    leaveEnd="opacity-0 -translate-y-16"
                                >
                                    <ClickableCard
                                    icon={<LibraryMusicIcon fontSize="large" sx={{ color: 'white' }} />}
                                    title="Discover New Music"
                                    body={
                                        <p className="text-gray-600 text-xl text-center pb-5">
                                            Find out what albums are trending each week and find your new favorite. 
                                        </p>}
                                    />
                                </Transition>

                                {/* Item 2 */}
                                <Transition
                                    show={tab === 2}
                                    appear={true}
                                    className="w-full h-full"
                                    enter="transition ease-in-out duration-700 transform order-first"
                                    enterStart="opacity-0 translate-y-16"
                                    enterEnd="opacity-100 translate-y-0"
                                    leave="transition ease-in-out duration-300 transform absolute"
                                    leaveStart="opacity-100 translate-y-0"
                                    leaveEnd="opacity-0 -translate-y-16"
                                >
                                    <ClickableCard
                                    icon={<StarRateIcon fontSize="large" sx={{ color: 'white' }} />}
                                    title="Rate and Review"
                                    body={
                                        <p className="text-gray-600 text-xl text-center pb-5">
                                        Channel the inner music critic in you and share your thoughts on albums. Rate each album on a five-star scale to record your review. 
                                        </p>
                                    }
                                    />
                                </Transition>

                                {/* Item 3 */}
                                <Transition
                                    show={tab === 3}
                                    appear={true}
                                    className="w-full h-full"
                                    enter="transition ease-in-out duration-700 transform order-first"
                                    enterStart="opacity-0 translate-y-16"
                                    enterEnd="opacity-100 translate-y-0"
                                    leave="transition ease-in-out duration-300 transform absolute"
                                    leaveStart="opacity-100 translate-y-0"
                                    leaveEnd="opacity-0 -translate-y-16"
                                >
                                    <ClickableCard
                                    icon={<PeopleIcon fontSize="large" sx={{ color: 'white' }} />}
                                    title="Follow Friends"
                                    body={
                                        <p className="text-gray-600 text-xl text-center pb-5">
                                        Stay up to date with what your friends are listening to via your curated Friends Feed. Share your favorite music with friends and discover new songs together. 
                                        </p>}
                                    big
                                    />
                                </Transition>

                                {/* Item 4 */}
                                <Transition
                                    show={tab === 4}
                                    appear={true}
                                    className="w-full h-full"
                                    enter="transition ease-in-out duration-700 transform order-first"
                                    enterStart="opacity-0 translate-y-16"
                                    enterEnd="opacity-100 translate-y-0"
                                    leave="transition ease-in-out duration-300 transform absolute"
                                    leaveStart="opacity-100 translate-y-0"
                                    leaveEnd="opacity-0 -translate-y-16"
                                >
                                    <ClickableCard
                                    icon={<HearingIcon fontSize="large" sx={{ color: 'white' }} />}
                                    title="Listen Later"
                                    body={
                                        <p className="text-gray-600 text-xl text-center pb-5">
                                            Keep track of all your must-hear tracks with your personalized "Listen Later" playlist.
                                        </p>
                                    }
                                    big
                                    />
                                </Transition>

                            </div>
                            </div >
                        </div>
                    </div >
                </div >
            </section>
            <Footer />
        </div>
    );
}

export default Landing;