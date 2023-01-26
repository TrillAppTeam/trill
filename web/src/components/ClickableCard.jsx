import React from 'react'

function ClickableCard ({ icon, title, body, big = false }) {
  return (
    <a className={`relative flex flex-col items-center p-6 bg-gray-600 cursor-pointer rounded shadow-xl ${big ? 'col-span-full' : 'col-span-full sm:col-span-1'} transition ease-in-out duration-150 hover:scale-105`} >
      <div className="bg-trillBlue p-3 rounded-full mb-2">{icon}</div>
      <h4 className="text-3xl font-bold leading-snug tracking-tight mb-1 text-white">{title}</h4>
      {body}
    </a >
  )
}

export default ClickableCard