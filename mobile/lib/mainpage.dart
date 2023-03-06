import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/pages/home.dart';
import 'package:trill/pages/loading_screen.dart';
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
        ? Scaffold(body: LoadingScreen())
        : Scaffold(
            appBar: AppBar(),
            drawer: Drawer(
              child: Container(
                color: Color(0xFF1A1B29),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(1000.0),
                          child: Image.asset("images/gerber.jpg",
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(height: 10),
                    Column(children: [
                      const Text(
                        'Matthew Gerber',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('@GerbersGrumblings'),
                    ]),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFBC6AAB), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Followers: 100',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, '/followers')),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFBC6AAB), width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Following: 100',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, '/following')),
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.home_outlined, color: Colors.white),
                      title: const Text('Home'),
                      onTap: () {
                        Navigator.pushNamed(context, '/main');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.library_music_outlined,
                          color: Colors.white),
                      title: const Text('Albums'),
                      onTap: () {
                        Navigator.pushNamed(context, '/albums');
                      },
                    ),
                    ListTile(
                      leading:
                          Icon(Icons.rate_review_outlined, color: Colors.white),
                      title: const Text('Reviews'),
                      onTap: () {
                        // TODO: Change back to /reviews
                        Navigator.pushNamed(context, '/review');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.format_list_bulleted_outlined,
                          color: Colors.white),
                      title: const Text('Listen Later'),
                      onTap: () {
                        Navigator.pushNamed(context, '/listenlater');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite_outline_outlined,
                          color: Colors.white),
                      title: const Text('Likes'),
                      onTap: () {
                        Navigator.pushNamed(context, '/likes');
                      },
                    ),
                    SizedBox(height: 30),
                    ListTile(
                        leading:
                            Icon(Icons.logout_outlined, color: Colors.white),
                        title: const Text('Log Out'),
                        onTap: () {
                          Amplify.Auth.signOut().then((_) {
                            Navigator.pushReplacementNamed(context, '/login');
                          });
                        }),
                  ],
                ),
              ),
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
