import 'package:flutter/material.dart';

class FollowUserButton extends StatefulWidget {
  final bool isFollowing;

  const FollowUserButton({super.key, required this.isFollowing});

  @override
  _FollowUserButtonState createState() => _FollowUserButtonState();
}

class _FollowUserButtonState extends State<FollowUserButton> {
  bool isFollowing = false;

  // MAKE API CALL
  @override
  void initState() {
    super.initState();
    isFollowing = widget.isFollowing;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFollowing = !isFollowing;
        });
      },
      child: Container(
        width: 80,
        height: 28,
        decoration: BoxDecoration(
          color: isFollowing ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Center(
          child: Text(
            isFollowing ? 'Unfollow' : 'Follow',
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
