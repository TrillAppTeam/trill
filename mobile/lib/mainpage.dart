import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
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
  final screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  // todo: pass user data to screens
  AuthUser? _user;
  String? _userEmail;
  String? _userNickname;
  CognitoAuthSession? cognitoSession;
  @override
  void initState() {
    super.initState();
    try {
      fetchAuthSession();
      // Amplify.Auth.getCurrentUser().then((user) {
      //   setState(() {
      //     _user = user;
      //   });
      // });
      // Amplify.Auth.fetchUserAttributes().then((attributes) {
      //   setState(() {
      //     // this is so scuffed lol
      //     for (final element in attributes) {
      //       if (element.userAttributeKey == CognitoUserAttributeKey.email) {
      //         _userEmail = element.value;
      //       } else if (element.userAttributeKey ==
      //           CognitoUserAttributeKey.nickname) {
      //         _userNickname = element.value;
      //       }
      //     }
      //   });
      // });
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> fetchAuthSession() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: CognitoSessionOptions(getAWSCredentials: true),
      );
      cognitoSession = result as CognitoAuthSession;
      safePrint('access token: ${cognitoSession!.userPoolTokens!.accessToken}');
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // temp appbar for button to test signing out
      // todo: implement button actually
      appBar: AppBar(
        // title: Text('Hello ${_userNickname!}'),
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
