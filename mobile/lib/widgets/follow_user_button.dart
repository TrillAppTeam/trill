import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';

class FollowUserButton extends StatefulWidget {
  final String username;
  final bool isFollowing;
  final void Function(bool)? onFollowed;

  const FollowUserButton({
    super.key,
    required this.username,
    required this.isFollowing,
    this.onFollowed,
  });

  @override
  _FollowUserButtonState createState() => _FollowUserButtonState();
}

class _FollowUserButtonState extends State<FollowUserButton> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_isFollowing) {
          final success = await unfollow(widget.username);
          if (success) {
            setState(() {
              _isFollowing = false;
            });
            if (widget.onFollowed != null) {
              widget.onFollowed!(false);
            }
          } else {
            safePrint('Failed to unfollow ${widget.username}');
          }
        } else {
          final success = await follow(widget.username);
          if (success) {
            setState(() {
              _isFollowing = true;
            });
            if (widget.onFollowed != null) {
              widget.onFollowed!(true);
            }
          } else {
            safePrint('Failed to follow ${widget.username}');
          }
        }
      },
      child: Container(
        width: 80,
        height: 28,
        decoration: BoxDecoration(
          color: _isFollowing ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Text(
            _isFollowing ? 'Unfollow' : 'Follow',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
