// Components and Utils
import FooterLanding from "../components/FooterLanding"
import { motion } from "framer-motion"

// Partials
import HeroSection from "../partials/HeroSection"
import FeaturesSection from "../partials/FeaturesSection"
import TeamSection from "../partials/TeamSection"
import AlbumsSection from "../partials/AlbumsSection"

function Landing() {
    
    return (
        <div className="bg-trillPurple min-h-screen text-center">           
            <motion.div
                initial={{ y: 30, opacity: 0 }}
                animate={{ y: 0, opacity: 1 }}
                transition={{ duration: 1.5 }}
            >
                <HeroSection />
                <AlbumsSection />
                <FeaturesSection />
                <TeamSection />
                <FooterLanding />
            </motion.div>
        </div>
    );
}

export default Landing;