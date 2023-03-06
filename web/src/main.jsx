import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import axios from 'axios';

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
import SearchResults from './pages/SearchResults';


import {
  createBrowserRouter,
  RouterProvider,
} from "react-router-dom";

import { QueryClient, QueryClientProvider} from "@tanstack/react-query";

// Define a default query function that will receive the query key
const defaultQueryFn = async ({ queryKey }) => {
  const data = await axios.get(`https://api.trytrill.com/main/${queryKey}`, { headers: {
      'Authorization' : `Bearer ${localStorage.getItem('access_token')}`
    }}).then((res) => {
      return res;
  });
  return data;
}

// provide the default query function to your app with defaultOptions
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      queryFn: defaultQueryFn,
      refetchOnWindowFocus: false,
    },
  },
})

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
        path: "Results",
        element: <SearchResults />,
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
        path: "Profile/:user",
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
