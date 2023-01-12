import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'

import FriendsFeed from './pages/FriendsFeed';
import ListenLater from './pages/ListenLater';
import Landing from './pages/Landing';
import Error from './pages/Error';
import Home from './pages/Home';

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
      }
    ],
  }
]);


ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <RouterProvider router={router} />
  </React.StrictMode>,
)
