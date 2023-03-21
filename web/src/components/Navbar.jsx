import { Link } from "react-router-dom";
import { Fragment } from 'react'

import { Disclosure, Menu, Transition } from '@headlessui/react'
import { Bars3Icon, XMarkIcon } from '@heroicons/react/24/outline'

import TrillLogo from "/trillTransparent.png"

// Components
import Avatar from "./Avatar"
import Search from "./Search"
import { useQuery } from "@tanstack/react-query";

const currentPath = window.location.pathname;

const navigation = [
  { name: 'Discover', link: '', current: currentPath === '/' },
  { name: 'Friends Feed', link: 'FriendsFeed', current: currentPath === '/FriendsFeed' },
  { name: 'Listen Later', link: 'ListenLater', current: currentPath === '/ListenLater' },
]

function handleLinkClick(clickedItem) {
  // Set the `current` property to true for the clicked link
  navigation.forEach((navItem) => {
    navItem.current = navItem.name === clickedItem.name;
  });
}

function resetLinks() {
  navigation.forEach((navItem) => {
    navItem.current = false;
  });
}


function classNames(...classes) {
  return classes.filter(Boolean).join(' ')
}

function Navbar() {
  const {error, data} = useQuery(['users'], {onSuccess: (data) => {sessionStorage.setItem("username", data.data.username)}});
  
  return (

      <Disclosure as="nav" className="bg-gray-700">
      {({ open }) => (
        <>
          <div className="mx-auto max-w-6xl px-2 sm:px-6 lg:px-8">
            <div className="relative flex h-16 items-center justify-between">
              
              {/* Mobile menu button*/}
              <div className="absolute inset-y-0 left-0 flex items-center sm:hidden">
                <Disclosure.Button className="inline-flex items-center justify-center rounded-md p-2 text-gray-200 hover:bg-gray-700 hover:text-gray-200 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-trillBlue">
                  <span className="sr-only">Open main menu</span>
                  {open ? (
                    <XMarkIcon className="block h-6 w-6" aria-hidden="true" />
                  ) : (
                    <Bars3Icon className="block h-6 w-6" aria-hidden="true" />
                  )}
                </Disclosure.Button>
              </div>
              
              <div className="flex flex-1 items-center justify-center sm:items-stretch sm:justify-start">
                <Link to="">
                  <div className="flex flex-shrink-0 items-center">
                    <img
                      className="block h-11 w-auto lg:hidden"
                      src={TrillLogo}
                      alt="Trill"
                    />
                    <img
                      className="hidden h-11 w-auto lg:block"
                      src={TrillLogo}
                      alt="Trill"
                    />
                  </div>
                </Link>
                <div className="hidden sm:ml-6 sm:block">
                  <div className="flex space-x-4">
                    {navigation.map((item) => (
                      <Link to={item.link}
                        key={item.name}
                        className= {`font-bold hover:bg-gray-600 px-3 py-2 rounded-md text-md ${item.current ? "text-trillBlue" : "text-gray-200"}`}
                        aria-current={item.current ? 'page' : undefined}
                        onClick={() => handleLinkClick(item)}
                      >
                        {item.name}
                      </Link>
                    ))}
                  </div>
                </div>
              </div>

              <div className="absolute inset-y-0 right-0 flex items-center pr-2 sm:static sm:inset-auto sm:ml-6 sm:pr-0">
                {/* Search Component */}
                <Search />
                
                {/* Profile dropdown */}
                <Menu as="div" className="relative ml-3">
                  <div>
                    <Menu.Button className="flex rounded-full pt-1">
                      <span className="sr-only">Open user menu</span>
                      <Avatar user={{ profile_picture: data?.data.profile_picture, username: data?.data.username, size: "11", linkDisabled: true }} />

                    </Menu.Button>
                  </div>
                  <Transition
                    as={Fragment}
                    enter="transition ease-out duration-100"
                    enterFrom="transform opacity-0 scale-95"
                    enterTo="transform opacity-100 scale-100"
                    leave="transition ease-in duration-75"
                    leaveFrom="transform opacity-100 scale-100"
                    leaveTo="transform opacity-0 scale-95"
                  >
                    <Menu.Items className="absolute right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-gray-600 py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none">
                      <Menu.Item>
                        {({ active }) => (
                          <Link to='Profile'
                            className={classNames(active ? 'bg-gray-700' : '', 'block px-4 py-2 text-sm text-gray-200 font-bold')}
                            state={{username: data?.data.username}}
                            onClick={() => resetLinks()}
                          >
                            Profile
                          </Link>
                        )}
                      </Menu.Item>
                      <Menu.Item>
                        {({ active }) => (
                          <Link to='MyReviews'
                            className={classNames(active ? 'bg-gray-700' : '', 'block px-4 py-2 text-sm text-gray-200 font-bold')}
                            onClick={() => resetLinks()}
                          >
                            My Reviews
                          </Link>
                        )}
                      </Menu.Item>
                      <Menu.Item>
                        {({ active }) => (
                          <Link to='/'
                            className={classNames(active ? 'bg-gray-700' : '', 'block px-4 py-2 text-sm text-gray-200 font-bold')}
                            onClick={() => resetLinks()}
                          >
                            Sign out
                          </Link>
                        )}
                      </Menu.Item>
                    </Menu.Items>
                  </Transition>
                </Menu>
              </div>
            </div>
          </div>

          <Disclosure.Panel className="sm:hidden">
            <div className="space-y-1 px-2 pt-2 pb-3">
              {navigation.map((item) => (
                <Disclosure.Button
                  key={item.name}
                  as="a"
                  href={item.href}
                  className= "text-gray-300 hover:bg-gray-500 hover:text-gray-200 block px-3 py-2 rounded-md font-bold"
                  aria-current={item.current ? 'page' : undefined}
                >
                  {item.name}
                </Disclosure.Button>
              ))}
            </div>
          </Disclosure.Panel>

        </>
      )}
    </Disclosure>
  );
}

export default Navbar;