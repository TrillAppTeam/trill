import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

// Pages
import FriendsFeed from './pages/FriendsFeed';
import ListenLater from './pages/ListenLater';
import ListAlbums from './pages/ListAlbums';
import Error from './pages/Error';
import Discover from './pages/Discover';
import Home from './pages/Home';
import CreateAccount from './pages/CreateAccount';
import Login from './pages/Login';
import Profile from './pages/Profile';
import Settings from './pages/Settings';
import AlbumDetails from './pages/AlbumDetails';


import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";

import { QueryClient, QueryClientProvider} from "@tanstack/react-query";

const queryClient = new QueryClient();

const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
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
    // TO DO: Update with userLoaderData once API is done
    path: "/:username",
    element: <Home />,
    errorElement: <Error />,
    children: [
      {
        path: "",
        element: <Discover />,
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
      },
      {
        path: "AlbumDetails",
        element: <AlbumDetails />,
        errorElement: <Error />
      }
    ],
  }
]);


ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <RouterProvider router={router} />
    </QueryClientProvider>
  </React.StrictMode>,
)
