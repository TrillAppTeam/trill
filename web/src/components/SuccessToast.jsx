import { useState } from "react"

function SuccessToast(props) {
    const [dismissed, setDismissed] = useState(false);

    const handleDismiss = () => {
        setDismissed(true);
        props.onDismiss();
      };

    return (
        <div className={`flex shadow-md gap-6 rounded-lg overflow-hidden divide-x max-w-2xl bg-gray-800 dark:text-gray-100 divide-gray-700 ${dismissed ? 'hidden' : ''}`}
        >
            <div className="flex flex-1 flex-col p-4 border-l-8 border-trillBlue">
                <span className="text-2xl">Success!</span>
                <span className="text-sm text-gray-400">{props.message}</span>
            </div>

            <button className="px-4 flex items-center text-xs uppercase tracking-wide text-gray-300 border-gray-600"
            onClick={handleDismiss}
            >
            Dismiss
            </button>
        </div>
      );
}

export default SuccessToast