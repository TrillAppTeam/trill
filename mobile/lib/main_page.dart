import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/friends_feed.dart';
import 'package:trill/pages/home.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/pages/search.dart';
import 'package:trill/widgets/sidebar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  String _title = 'Home';
  late List<Widget> _screens;

  late SharedPreferences _prefs;
  bool _userInfoSet = false;

  late DetailedUser _user;

  @override
  void initState() {
    super.initState();
    try {
      setUserInfo();
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> setUserInfo() async {
    await fetchAuthSession();
    await getCognitoUser();

    _user = (await getDetailedUser())!;
    _screens = [
      HomeScreen(
        nickname: _user.nickname,
      ),
      const SearchScreen(),
      const FriendsFeedScreen(),
      ProfileScreen(
        username: _user.username,
      ),
    ];

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

      _prefs = await SharedPreferences.getInstance();
      await _prefs.setString(
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
      _prefs = await SharedPreferences.getInstance();

      await _prefs.setString('username', user.username);
      safePrint('stored username: ${user.username}');

      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in attributes) {
        await _prefs.setString(
          element.userAttributeKey.toString(),
          element.value,
        );

        safePrint(
            'stored ${element.userAttributeKey.toString()}: ${element.value}');
      }
    } on AmplifyAlreadyConfiguredException catch (e) {
      safePrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_userInfoSet
        ? const Scaffold(
            backgroundColor: Color(0xFF1A1B29),
            body: LoadingScreen(),
          )
        : Scaffold(
            backgroundColor: const Color(0xFF1A1B29),
            appBar: AppBar(
              title: Text(_title),
            ),
            drawer: Sidebar(
                user: _user,
                onUserUpdated: (DetailedUser user) {
                  setState(() {
                    _user = user;
                  });
                }),
            // IndexedStack keeps the states of each page
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3FBCF4).withOpacity(.2),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF1A1B29),
                selectedItemColor: const Color(0xFF3FBCF4),
                unselectedItemColor: const Color(0xFF888888),
                showUnselectedLabels: false,
                showSelectedLabels: false,
                iconSize: 30,
                elevation: 10,
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  switch (index) {
                    case 0:
                      _title = 'Home';
                      break;
                    case 1:
                      _title = 'Search';
                      break;
                    case 2:
                      _title = 'Friends Feed';
                      break;
                    case 3:
                      _title = 'My Profile';
                      break;
                  }
                },
                items: const [
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
                    icon: Icon(Icons.people_alt_outlined),
                    activeIcon: Icon(Icons.people_alt),
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
