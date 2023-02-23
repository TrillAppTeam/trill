import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  // todo: need to fix how user info is saved so that we don't call use any info before it's saved
  late SharedPreferences prefs;
  bool _setAccessToken = false;

  @override
  void initState() {
    super.initState();
    try {
      fetchAuthSession();
      getCognitoUser();
    } on AuthException catch (e) {
      print(e.message);
    }
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
      safePrint('access token: ${cognitoSession.userPoolTokens!.accessToken}');

      setState(() {
        _setAccessToken = true;
      });
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> getCognitoUser() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', user.username);

      final attributes = await Amplify.Auth.fetchUserAttributes();
      for (final element in attributes) {
        await prefs.setString(
          element.userAttributeKey.toString(),
          element.value,
        );
      }
    } on AmplifyAlreadyConfiguredException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_setAccessToken
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            // temp appbar for button to test signing out
            // todo: implement button actually
            appBar: AppBar(
              actions: [
                MaterialButton(
                  onPressed: () {
                    Amplify.Auth.signOut().then((_) {
                      Navigator.pushReplacementNamed(context, '/entry');
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