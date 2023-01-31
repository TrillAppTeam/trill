import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

import FriendsFeed from './pages/FriendsFeed';
import ListenLater from './pages/ListenLater';
import Landing from './pages/Landing';
import ListAlbums from './pages/ListAlbums';
import Error from './pages/Error';
import Home from './pages/Home';
import CreateAccount from './pages/CreateAccount';
import Login from './pages/Login';
import Profile from './pages/Profile';
import Settings from './pages/Settings';

import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Landing />,
    errorElement: <Error />,
    children: [
    ],
  },
  {
    path: "/CreateAccount",
    element: <CreateAccount />,
    errorElement: <Error />
  },
  {
    path: "/Login",
    element: <Login />,
    errorElement: <Error />
  },
  {
    path: "/User",
    element: <App />,
    errorElement: <Error />,
    children: [
      {
        path: "Home",
        element: <Home />,
        errorElement: <Error />
      },
      {
        path: "FriendsFeed",
        element: <FriendsFeed />,
        errorElement: <Error />
      },
      {
        path: "ListenLater",
        element: <ListenLater />,
        errorElement: <Error />
      },
      {
        path: "More",
        element: <ListAlbums />,
        errorElement: <Error />
      },
      {
        path: "Profile",
        element: <Profile />,
        errorElement: <Error />
      },
      {
        path: "Settings",
        element: <Settings />,
        errorElement: <Error />
      }
    ],
  }
]);


ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
)
