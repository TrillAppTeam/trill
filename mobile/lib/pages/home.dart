import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/follows.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nickname;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    follow("dmflo");
    unfollow("avwede");
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // nickname = _prefs.getString('nickname')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Image.asset("images/gerber.jpg", fit: BoxFit.cover)),
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
              Container(
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBC6AAB), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Followers: 100',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.pushNamed(context, '/followers')),
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFBC6AAB), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Following: 100',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.pushNamed(context, '/following')),
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                ),
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
                leading:
                    Icon(Icons.library_music_outlined, color: Colors.white),
                title: const Text('Albums'),
                onTap: () {
                  Navigator.pushNamed(context, '/albums');
                },
              ),
              ListTile(
                leading: Icon(Icons.rate_review_outlined, color: Colors.white),
                title: const Text('Reviews'),
                onTap: () {
                  Navigator.pushNamed(context, '/reviews');
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
                leading:
                    Icon(Icons.favorite_outline_outlined, color: Colors.white),
                title: const Text('Likes'),
                onTap: () {
                  Navigator.pushNamed(context, '/likes');
                },
              ),
              SizedBox(height: 30),
              ListTile(
                leading: Icon(Icons.logout_outlined, color: Colors.white),
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nickname != null ? 'hello, $nickname!' : 'hello!',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Popular Albums This Month',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Image links will go here
              SizedBox(height: 20),
              Text(
                'Popular Albums Among Friends',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              // Image links will go here
              SizedBox(height: 20),
              Text(
                'Recent Friends Reviews',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  color: Color(0x1f989696),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '"I wasn\'t a fan at first, but now I can\'t stop listening!"',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  color: Color(0x1f989696),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '"This album is definitely worth checking out!"',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38,
                  ),
                  color: Color(0x1f989696),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '"My name is Wesley Wales Anderson and if I were a music album, this would be me!"',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
