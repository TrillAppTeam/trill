import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int currentIndex = 0;
  final List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const ProfileScreen(),
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
      safePrint(e.message);
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
      safePrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo: set trill loading screen if user info not set
    return !_userInfoSet
        ? const Scaffold(body: LoadingScreen())
        : Scaffold(
            appBar: AppBar(),
            drawer: const Sidebar(),
            // IndexedStack keeps the states of each page
            body: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFBC6AAB).withOpacity(.2),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: const Color(0xFF1A1B29),
                selectedItemColor: const Color(0xFFBC6AAB),
                unselectedItemColor: const Color(0xFF888888),
                showUnselectedLabels: false,
                iconSize: 30,
                elevation: 10,
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
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
