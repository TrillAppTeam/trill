import { useState } from "react"
import { motion } from "framer-motion"


function Toast(props) {
    const { message, type } = props.toast;
    const [ dismissed, setDismissed ] = useState(false);
    const [ isSuccess, setIsSuccess ] = useState(false);

    const handleDismiss = () => {
        setDismissed(true);
        setIsSuccess(false);
        props.toast.onDismiss();
      };

    return (
        <>
        <motion.div
            className="box"
            initial={{ opacity: 0, scale: 0.5 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{
                duration: 0.8,
                delay: 0.5,
                ease: [0, 0.71, 0.2, 1.01]
            }}
        >

            <div className={`flex shadow-md gap-6 rounded-lg overflow-hidden divide-x max-w-2xl bg-[#383b59] text-gray-100 divide-gray-500 ${dismissed ? 'hidden' : ''}`}>
                <div className={`flex flex-1 flex-col p-4 border-l-8 ${type == "success" ? 'border-green-500' : 'border-red-500'}`}>
                    <span className={`text-2xl ${type == "success" ? 'text-green-500' : 'text-red-500'}`}>
                        {type == "success" ? "Success!" : "Error"}
                    </span>
                    
                    <span className="text-sm text-gray-300">{message}</span>
                </div>

                <button className="px-4 flex items-center text-xs uppercase tracking-wide text-gray-300 "
                onClick={handleDismiss}
                >
                Dismiss
                </button>
            </div>

        </motion.div>
        </>
      );
}

export default Toast