import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/edit_profile.dart';
import 'package:trill/pages/lists/follows.dart';
import 'package:trill/widgets/follow_button.dart';

import '../api/follows.dart';

class Sidebar extends StatefulWidget {
  final PrivateUser user;
  final Function onUserUpdated;

  const Sidebar({
    super.key,
    required this.user,
    required this.onUserUpdated,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late PublicUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

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
                Column(
                  children: [
                    Text(
                      _user.nickname,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('@${_user.username}'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                FollowButton(
                  username: _user.username,
                  followType: FollowType.following,
                ),
                const Spacer(flex: 2),
                FollowButton(
                  username: _user.username,
                  followType: FollowType.follower,
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
              leading:
                  const Icon(Icons.rate_review_outlined, color: Colors.white),
              title: const Text('Reviews'),
              onTap: () {
                Navigator.pushNamed(context, '/reviews');
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
              leading: const Icon(Icons.favorite_outline_outlined,
                  color: Colors.white),
              title: const Text('Likes'),
              onTap: () {
                Navigator.pushNamed(context, '/likes');
              },
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.white),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      initialBio: _user.bio,
                      initialNickname: _user.nickname,
                      initialProfilePic: _user.profilePic,
                      onUserChanged: () async {
                        await _fetchUserDetails();
                        widget.onUserUpdated(_user);
                      },
                    ),
                  ),
                );
              },
            ),
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
