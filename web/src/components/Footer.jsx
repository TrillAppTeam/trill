import React from 'react'
 
function Footer () {
  return (
    <footer>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 bg-trillPurple pt-5">

        <div className="grid grid-cols-2 border-t border-gray-200 pt-5 pb-5 ">

          {/* Trill Logo */}
          <div className="flex justify-center">
            <img className="w-[150px]" src='/trillTransparent.png' />
          </div>

          {/* Contact Us */}
          <div className="flex justify-center">
            <div className="">
              <h6 className="font-bold text-gray-100 text-md sm:text-lg mb-2">Contact Us</h6>
              <ul className="text-sm sm:text-md text-gray-100">
                <li className="mb-2">Trill</li>
                <li className="mb-2">Orlando, FL</li>
                <li className="mb-2">trillappteam@gmail.com</li>
              </ul>
            </div>
          </div>

        </div>
      </div>
    </footer>
  )
}

export default Footer