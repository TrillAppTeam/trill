import { Link } from "react-router-dom";
import ArrowRightIcon from '@mui/icons-material/ArrowRight';

function Titles(props) {
    return (
        <div>
            <div className="flex max-w-6xl mx-auto justify-between text-gray-400 pr-1 pl-1">
                {props.title}

                {props.title === "News" ? "" : 
                    <Link to="/User/More">
                        More <ArrowRightIcon />
                    </Link> 
                }
                
            </div>

            <div className="border-t border-gray-400 pt-5 pb-5 max-w-6xl mx-auto" />
        </div>
    );
}

export default Titles;