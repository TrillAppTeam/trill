import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

function Search() {
    const [searchTerm, setSearchTerm] = useState('');
    const [dropdownOpen, setDropdownOpen] = useState(false);
    const [selectedOption, setSelectedOption] = useState('Albums');
    const navigate = useNavigate();
    
    const handleSearchSubmit = (event) => {
        event.preventDefault();
        console.log(`Searching for ${searchTerm} in ${selectedOption}`);
        navigate("/User/Results", {state : {query: searchTerm, type: selectedOption}});
    };
    
    const handleDropdownClick = () => {
        setDropdownOpen(!dropdownOpen);
    };
    
    const handleOptionClick = (option) => {
        setSelectedOption(option);
        setDropdownOpen(false);
    };

    return (
        <div className="pr-5">
            <form onSubmit={handleSearchSubmit} className="relative w-full">
                <div className="flex">
                    <input
                    type="text"
                    placeholder="Search"
                    className="w-54 px-4 py-2.5 text-sm text-gray-200 bg-gray-700 rounded-l-lg border-l-2 border-gray-400 focus:ring-trillBlue focus:border-trillBlue"
                    value={searchTerm}
                    onChange={(event) => setSearchTerm(event.target.value)}
                    />
                    <button
                    type="button"
                    className="w-24 flex-shrink-0 inline-flex items-center justify-center py-2.5 px-4 text-sm font-bold text-gray-200 bg-gray-800 border border-gray-400 rounded-r-lg hover:bg-gray-600 focus:outline-none focus:ring-gray-100"
                    onClick={handleDropdownClick}
                    >
                    {selectedOption}{' '}
                    <svg
                        className="w-4 h-4 ml-1"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                        fillRule="evenodd"
                        d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
                        clipRule="evenodd"
                        />
                    </svg>
                    </button>

                    {dropdownOpen && (
                    <div className="absolute right-0 top-0 z-10 w-24 bg-gray-800 border border-gray-400 hover:border-trillBlue divide-y divide-gray-200 rounded-md shadow-lg">
                        <button
                        type="button"
                        className="w-full py-2.5 px-2 text-sm text-gray-200 hover:bg-gray-700 font-bold"
                        onClick={() => handleOptionClick('Albums')}
                        >
                        Albums
                        </button>
                        <button
                        type="button"
                        className="w-full py-2.5 px-2 text-sm text-gray-200 hover:bg-gray-700 font-bold"
                        onClick={() => handleOptionClick('Users')}
                        >
                        Users
                        </button>
                    </div>
                    )}
                    
                </div>
            </form>
        </div>
    );
}

export default Search;