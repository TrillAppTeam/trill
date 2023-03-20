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
    return InkWell(
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
          color:
              _isFollowing ? const Color(0xFF3FBCF4) : const Color(0xFF374151),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            _isFollowing ? 'UNFOLLOW' : 'FOLLOW',
            style: TextStyle(
              color: _isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
