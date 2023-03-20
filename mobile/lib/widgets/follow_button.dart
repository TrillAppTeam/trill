import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/lists/follows.dart';

class FollowButton extends StatefulWidget {
  final DetailedUser user;
  final FollowType followType;

  const FollowButton({
    super.key,
    required this.user,
    required this.followType,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FollowsScreen(
              username: widget.user.username,
              followType: widget.followType,
            ),
          ),
        );
      },
      child: Container(
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
          child: Text(
            widget.followType == FollowType.following
                ? 'Following: ${widget.user.following.length}'
                : 'Followers: ${widget.user.followers.length}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
