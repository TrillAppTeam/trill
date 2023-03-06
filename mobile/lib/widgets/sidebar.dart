import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/edit_profile.dart';

import '../api/follows.dart';

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
        color: const Color(0xFF1A1B29),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000.0),
                child: Image.asset("images/gerber.jpg", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 40),
                Column(
                  children: [
                    Text(
                      _user != null ? _user!.nickname : 'Loading...',
                      style: const TextStyle(
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
                  icon: const Icon(
                    Icons.edit,
                    color: Color(0xFFDDDDDD),
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFBC6AAB),
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: FutureBuilder<Follow?>(
                      future: getFollowers(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String followerCount =
                          snapshot.data!.users.length.toString();
                          return RichText(
                            text: TextSpan(
                              text: 'Followers: $followerCount',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(
                                  context,
                                  '/followers',
                                ),
                            ),
                          );
                        } else {
                          return const Text('Loading');
                        }
                      },
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFBC6AAB), width: 1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    child: FutureBuilder<Follow?>(
                      future: getFollowing(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String followingCount =
                          snapshot.data!.users.length.toString();
                          return RichText(
                            text: TextSpan(
                              text: 'Following: $followingCount',
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(
                                    context, '/following'),
                            ),
                          );
                        } else {
                          return const Text('Loading');
                        }
                      },
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Colors.white),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/main');
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_music_outlined, color: Colors.white),
              title: const Text('Albums'),
              onTap: () {
                Navigator.pushNamed(context, '/albums');
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review_outlined, color: Colors.white),
              title: const Text('Reviews'),
              onTap: () {
                // TODO: Change back to /reviews
                Navigator.pushNamed(context, '/review');
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_bulleted_outlined,
                  color: Colors.white),
              title: const Text('Listen Later'),
              onTap: () {
                Navigator.pushNamed(context, '/listenlater');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.favorite_outline_outlined, color: Colors.white),
              title: const Text('Likes'),
              onTap: () {
                Navigator.pushNamed(context, '/likes');
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.logout_outlined, color: Colors.white),
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
