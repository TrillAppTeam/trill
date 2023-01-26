import TrillLogo from "/trillTransparent.png"
import GitHubIcon from '@mui/icons-material/GitHub';

function Footer() {
    return (
        <footer className="footer items-center p-4 bg-gray-700 text-gray-200">
            <div className="items-center grid-flow-col">
                <img src={TrillLogo} className="w-12" />
                <p>Copyright Trill © 2023 - All right reserved</p>
            </div> 
            <div className="grid-flow-col gap-4 md:place-self-center md:justify-self-end">
                <a href="https://github.com/TrillAppTeam/trill" target="_blank"><GitHubIcon /></a> 
            </div>
        </footer>
    );
}

export default Footer