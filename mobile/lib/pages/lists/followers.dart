import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import '../../api/users.dart';
import '../../widgets/user_row.dart';
import '../profile.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  Follow? _userResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    Follow? userResults = await getFollowers();

    setState(() {
      _userResults = userResults!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) :
        ListView.builder(
          itemCount: _userResults?.users.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      username: _userResults?.users![index],
                    ),
                  ),
                );
              },
              child: ListTile(
                  title: Text(
                    (_userResults?.users![index])!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_outlined,
                      color: Colors.white.withOpacity(0.2)))
          );
        }
      )
    );
  }
}
