import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/edit_profile.dart';
import 'package:trill/pages/lists/liked_reviews.dart';
import 'package:trill/pages/lists/listen_later.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/widgets/follow_button.dart';
import 'package:trill/widgets/profile_pic.dart';

class Sidebar extends StatefulWidget {
  final DetailedUser user;
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
  late DetailedUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _fetchUserDetails() async {
    final user = await getDetailedUser();
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
            const SizedBox(height: 75),
            Container(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
              child: ProfilePic(
                user: _user,
                radius: 48,
                fontSize: 32,
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
                  user: _user,
                  followType: FollowType.following,
                ),
                const Spacer(flex: 2),
                FollowButton(
                  user: _user,
                  followType: FollowType.follower,
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 30),
            ListTile(
              leading:
                  const Icon(Icons.rate_review_outlined, color: Colors.white),
              title: const Text('Liked Reviews'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LikedReviewsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_bulleted_outlined,
                  color: Colors.white),
              title: const Text('Listen Later'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListenLaterScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.white),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      initialUser: _user,
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login(),
                      ),
                    );
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
