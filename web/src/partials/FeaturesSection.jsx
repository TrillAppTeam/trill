import React, { useEffect, useRef, useState } from 'react'

// Components and Utils
import Transition from '../utils/Transition'
import ClickableCard from "../components/ClickableCard"

// Material UI Icons
import PeopleIcon from '@mui/icons-material/People'
import HearingIcon from '@mui/icons-material/Hearing'
import LibraryMusicIcon from '@mui/icons-material/LibraryMusic'
import StarRateIcon from '@mui/icons-material/StarRate'

function FeaturesSection() {
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
        <div className="mx-auto px-4 sm:px-6 mb-8 pb-10">
            <h1 className="p-10 italic font-bold text-4xl sm:text-5xl text-gray-100 pb-10">Explore Trill's Features</h1>

            <div className="w-full min-w-48">
                <div className="md:grid md:grid-cols-12 md:gap-6 max-w-6xl mx-auto">

                {/* Content */}
                <div className="max-w-xl md:max-w-none md:w-full mx-auto md:col-span-7 lg:col-span-6" data-aos="fade-right">
                    <div className="mb-8 md:mb-0">
                        <a
                            className={`flex items-center text-lg bg-gray-600 text-white p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 1 ? 'border-transparent' : 'bg-gray-500 '}`}
                            href="#0"
                            onClick={(e) => { e.preventDefault(); setTab(1) }}
                        >
                            <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                <div>Discover New Music</div>
                                <LibraryMusicIcon />
                            </div>
                        </a>
                        <a
                            className={`flex items-center text-lg bg-gray-600 text-white p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 2 ? 'border-transparent' : 'bg-gray-500'}`}
                            href="#0"
                            onClick={(e) => { e.preventDefault(); setTab(2) }}
                        >
                            <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                <div>Rate and Review</div>
                                <StarRateIcon />
                            </div>
                        </a>
                        <a
                            className={`flex items-center text-lg bg-gray-600 text-white p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 3 ? 'border-transparent' : 'bg-gray-500'}`}
                            href="#0"
                            onClick={(e) => { e.preventDefault(); setTab(3) }}
                        >
                            <div className="w-full flex justify-between font-bold leading-snug tracking-tight mb-1">
                                <div>Follow Friends</div>
                                <PeopleIcon />
                            </div>
                        </a>
                        <a
                            className={`flex items-center text-lg bg-gray-600 text-white p-5 rounded border transition duration-300 ease-in-out mb-3 ${tab !== 4 ? 'border-transparent' : 'bg-gray-500 '}`}
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

                {/* Cards for Features */}
                <div className="max-w-xl md:max-w-none md:w-full mx-auto md:col-span-5 lg:col-span-6 mb-8 md:mb-0 md:order-1" data-aos="zoom-y-out" ref={tabs}>
                    <div className="relative flex flex-col text-center text-gray-900 lg:text-right h-full">

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
                                <p className="text-white text-xl text-center pb-5">
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
                                <p className="text-gray-200 text-xl text-center pb-5">
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
                                <p className="text-gray-200 text-xl text-center pb-5">
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
                                <p className="text-gray-200 text-xl text-center pb-5">
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
    );
}

export default FeaturesSection