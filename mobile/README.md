# trill

:)

## Amplify Configuration Instructions

In order to configure Amplify, click on [this link](https://us-east-1.admin.amplifyapp.com/admin/d2mwv2d69p82k6/staging/home) and follow these steps:

- Click `Local setup instructions` in the top right corner
- Install Amplify CLI if not already installed
- Run the command under local setup instructions under `/mobile` (e.g. `amplify pull --appId d2mwv2d69p82k6 --envName staging`)
  - Accept defaults as appropriate

In addition to in Cognito, you can view the Cognito User Pool under the `User Management` page.

---

## Demo things
- Home Page - Prathik
  - Home Page UI
    - Popular Albums this week - Cathy
    - Recent News
    - Hello Grammys
    - Trill Favorites
  - Connect Home Page to popular albums API

- Profile page - Cathy
  - Change UI for profile page to more match web
  - All review list at bottom of profile
  - Favorite albums - Prathik
    - Connect to favorite albums UI
    - Hold to delete favorite album
  - Follow other users
    - Separate logged in user vs other users

- Friends Feed - Cathy
  - UI
  - Connect to API

- Navigation - Cathy
  - Persist bottom nav on every page
  - App bar on each page
    - Sidebar button becomes back button when navigating

- Album Details + Reviews - Cathy
  - List is in the dart file

- Sidebar - Prathik
  - Fix calling user API
  - UI
    - Account details
    - Listen later
    - Liked reviews
    - Review list
    - Edit profile
    - Logout

- UI!!
  - Implement profile pics everywhere

---

APIs we need:
- Profile pictures
- Popular albums globally
  - Set time limit (e.g. this week, this month)
- User data for follows
- Add follow counts when getting a public user
- User data for reviews
- Album details when getting reviews
  - For reviews on profile page, friends feed, and anywhere other than album details
- Liked reviews list
  - Also need album details
- Listen later
