import TrillLogo from "/trillTransparent.png"
import GitHubIcon from '@mui/icons-material/GitHub';

function Footer() {
    return (
        <footer className="p-4 bg-gray-700 text-gray-200">
            <div className="flex flex-row justify-between max-w-6xl mx-auto">
                <div className="flex flex-row gap-3">
                    <img src={TrillLogo} className="w-12" />
                    <p className="italic text-sm my-auto">Copyright Trill © 2023 - All right reserved</p>
                </div>
                <div className="my-auto tooltip" data-tip="Check out our GitHub!">
                    <a href="https://github.com/TrillAppTeam/trill" target="_blank"><GitHubIcon /></a> 
                </div>
            </div>  
        </footer>
    );
}

export default Footer