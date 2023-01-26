import { Link } from "react-router-dom"

// Components and Utils
import FooterLanding from "../components/FooterLanding"

// Partials
import HeroSection from "../partials/HeroSection"
import FeaturesSection from "../partials/FeaturesSection"
import TeamSection from "../partials/TeamSection"

function Landing() {
    
    return (
        <div className="bg-trillPurple min-h-screen text-center">           

            <HeroSection />

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

            
            <FeaturesSection />
            <TeamSection />
            <FooterLanding />
        </div>
    );
}

export default Landing;