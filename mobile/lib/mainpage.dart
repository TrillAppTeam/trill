import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/pages/home.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/pages/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final List<Widget> screens = [
    AlbumDetailsScreen(
      album: SpotifyAlbum.fromJson(jsonDecode('''
{
  "album_type": "album",
  "external_urls": {
    "spotify": "https://open.spotify.com/album/4aawyAB9vmqN3uQ7FjRGTy"
  },
  "href": "https://api.spotify.com/v1/albums/4aawyAB9vmqN3uQ7FjRGTy",
  "id": "4aawyAB9vmqN3uQ7FjRGTy",
  "images": [
    {
      "url": "https://i.scdn.co/image/ab67616d0000b2732c5b24ecfa39523a75c993c4",
      "height": 640,
      "width": 640
    },
    {
      "url": "https://i.scdn.co/image/ab67616d00001e022c5b24ecfa39523a75c993c4",
      "height": 300,
      "width": 300
    },
    {
      "url": "https://i.scdn.co/image/ab67616d000048512c5b24ecfa39523a75c993c4",
      "height": 64,
      "width": 64
    }
  ],
  "name": "Global Warming",
  "release_date": "2012-11-16",
  "type": "album",
  "uri": "spotify:album:4aawyAB9vmqN3uQ7FjRGTy",
  "genres": [],
  "label": "Mr.305/Polo Grounds Music/RCA Records",
  "popularity": 56,
  "artists": [
    {
      "id": "0TnOYISbd1XYRBk9myaseg",
      "name": "Pitbull",
      "type": "artist",
      "uri": "spotify:artist:0TnOYISbd1XYRBk9myaseg"
    }
  ]
}
''')),
      reviews: List<Review>.from(json
          .decode('''[
  "{\"review_id\":807,\"username\":\"dmflo\",\"album_id\":\"testingupdate\",\"rating\":5000,\"review_text\":\"\",\"created_at\":\"2023-02-22T07:35:41Z\",\"updated_at\":\"2023-02-22T07:35:41Z\",\"likes\":0,\"requestor_liked\":false}",
  "{\"review_id\":805,\"username\":\"csmi\",\"album_id\":\"testingupdate\",\"rating\":3,\"review_text\":\"\",\"created_at\":\"2023-02-17T19:12:41Z\",\"updated_at\":\"2023-02-17T19:12:42Z\",\"likes\":1,\"requestor_liked\":true}",
  "{\"review_id\":802,\"username\":\"avwede\",\"album_id\":\"testingupdate\",\"rating\":3,\"review_text\":\"yay\",\"created_at\":\"2023-02-12T21:34:52Z\",\"updated_at\":\"2023-02-12T21:34:53Z\",\"likes\":0,\"requestor_liked\":false}",
  "{\"review_id\":800,\"username\":\"cathychian\",\"album_id\":\"testingupdate\",\"rating\":7,\"review_text\":\"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.\",\"created_at\":\"2023-02-08T22:32:40Z\",\"updated_at\":\"2023-02-27T08:57:59Z\",\"likes\":2,\"requestor_liked\":false}"
]''').map(
              (x) => Review.fromJson(x))),
    ),
    // HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  // todo: need to fix how user info is saved so that we don't call use any info before it's saved
  late SharedPreferences prefs;
  bool _userInfoSet = false;

  @override
  void initState() {
    super.initState();
    try {
      setUserInfo();
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> setUserInfo() async {
    await fetchAuthSession();
    await getCognitoUser();

    setState(() {
      _userInfoSet = true;
      safePrint('user info set!');
    });
  }

  Future<void> fetchAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );

      final cognitoSession = result as CognitoAuthSession;

      prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'token', cognitoSession.userPoolTokens!.accessToken);

      safePrint(
          'stored access token: ${cognitoSession.userPoolTokens!.accessToken}');
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> getCognitoUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      prefs = await SharedPreferences.getInstance();

      await prefs.setString('username', user.username);
      safePrint('stored username: ${user.username}');

      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in attributes) {
        await prefs.setString(
          element.userAttributeKey.toString(),
          element.value,
        );

        safePrint(
            'stored ${element.userAttributeKey.toString()}: ${element.value}');
      }
    } on AmplifyAlreadyConfiguredException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo: set trill loading screen if user info not set
    return !_userInfoSet
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            // temp appbar for button to test signing out
            // todo: implement button actually
            appBar: AppBar(
              actions: [
                MaterialButton(
                  onPressed: () {
                    Amplify.Auth.signOut().then((_) {
                      Navigator.pushReplacementNamed(context, '/login');
                    });
                  },
                  child: Icon(Icons.logout),
                ),
              ],
            ),
            // IndexedStack keeps the states of each page
            body: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFBC6AAB).withOpacity(.2),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Color(0xFF1A1B29),
                selectedItemColor: Color(0xFFBC6AAB),
                unselectedItemColor: Color(0xFF888888),
                showUnselectedLabels: false,
                iconSize: 30,
                elevation: 10,
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: '____',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_outlined),
                    activeIcon: Icon(Icons.search),
                    label: '____',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline_outlined),
                    activeIcon: Icon(Icons.person),
                    label: '____',
                  ),
                ],
              ),
            ),
          );
  }
}
