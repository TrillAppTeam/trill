import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/constants.dart';
import '../../widgets/follow_user_button.dart';
import '../profile.dart';

class FollowsScreen extends StatefulWidget {
  final String username;
  final FollowType followType;

  const FollowsScreen({
    super.key,
    required this.username,
    required this.followType,
  });

  @override
  State<FollowsScreen> createState() => _FollowsScreenState();
}

class _FollowsScreenState extends State<FollowsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late Follow _userResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.followType == FollowType.follower ? 1 : 0,
    );
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    Follow? userResults;
    if (_tabController!.index == 1) {
      userResults = await getFollowers(widget.username);
    } else {
      userResults = await getFollowing(widget.username);
    }

    setState(() {
      _userResults = userResults!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B29),
      appBar: AppBar(
        title: const Text('Follows'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Following'),
            Tab(text: 'Followers'),
          ],
          onTap: (index) {
            setState(() {
              _tabController!.index = index;
            });
            _fetchUserDetails();
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchUserDetails,
        backgroundColor: const Color(0xFF1A1B29),
        color: const Color(0xFF3FBCF4),
        child: ListView.builder(
          itemCount: _userResults.users.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      username: _userResults.users[index].username,
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  (_userResults.users[index].username),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text((_userResults.users[index].nickname)),
                leading: const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
                  ),
                ),
                trailing: _tabController!.index == 0
                    ? FollowUserButton(
                  username: _userResults.users[index].username,
                  isFollowing: true,
                )
                    : Icon(
                  Icons.arrow_forward_outlined,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            );
          },
        ),
      ),
    );
  }}
