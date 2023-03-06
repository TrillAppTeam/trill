import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/edit_profile.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({
    Key? key,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  PublicUser? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  // need to change how user details are gotten
  Future<void> _fetchUserDetails() async {
    final user = await getPublicUser();
    setState(() {
      _user = user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                child: Image.asset("images/gerber.jpg", fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      _user != null ? _user!.nickname : 'Loading...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('@${_user != null ? _user!.username : 'Loading...'}'),
                  ],
                ),
                // temp location, can't click when still loading
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          initialBio: _user != null ? _user!.bio : '',
                          initialNickname: _user != null ? _user!.nickname : '',
                          initialProfilePic:
                              _user != null ? _user!.profilePic : '',
                          onUserChanged: _fetchUserDetails,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xFFDDDDDD),
                    size: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFBC6AAB),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Followers: 100',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/followers'),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 2),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFBC6AAB), width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Following: 100',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/following'),
                      ),
                    ),
                  ),
                ),
                Spacer(),
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
              leading: Icon(Icons.library_music_outlined, color: Colors.white),
              title: const Text('Albums'),
              onTap: () {
                Navigator.pushNamed(context, '/albums');
              },
            ),
            ListTile(
              leading: Icon(Icons.rate_review_outlined, color: Colors.white),
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
                Amplify.Auth.signOut().then(
                  (_) {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
