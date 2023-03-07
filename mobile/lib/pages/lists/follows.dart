import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import '../profile.dart';

enum FollowType {
  following,
  follower,
}

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
  Follow? _userResults;
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
          : ListView.builder(
              itemCount: _userResults?.users.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          username: _userResults?.users[index],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      (_userResults?.users[index])!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
