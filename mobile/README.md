# trill

:(

## Amplify Configuration Instructions

In order to configure Amplify, click on [this link](https://us-east-1.admin.amplifyapp.com/admin/d2mwv2d69p82k6/staging/home) and follow these steps:

- Click `Local setup instructions` in the top right corner
- Install Amplify CLI if not already installed
- Run the command under local setup instructions under `/mobile` (e.g. `amplify pull --appId d2mwv2d69p82k6 --envName staging`)
  - Accept defaults as appropriate

In addition to in Cognito, you can view the Cognito User Pool under the `User Management` page.

---

## Demo things

Test on physical device

API
- Profile pic API
- Add pagination
- Prevent adding to listen later when reviewed

UI!!
- Copy web for everything
- Loading page
- Fix overflowing review tiles
- Animations for everything (e.g. fading out when something is deleted, swipe to delete listen later)

Bugs:
- Can't scroll to the bottom of album details reviews because I put it in a sizedbox. When I don't put it in a sizedbox, the app crashes since the listview expands vertically infinitely. I have spent probably 15 hours trying to fix this over the past week and chatgpt can't fix it so I give up. It has to do with putting the listview in the tabbarview that changed the vertical constraints of the listview, since it worked fine before that, but no matter what i've tried i still get the same error

---

## Stretch goals

- Link to Spotify album url and open up album in Spotify app
  - Web has this but it's much hard/maybe impossible on mobile
- Easier way to delete listen later and favorite albums
