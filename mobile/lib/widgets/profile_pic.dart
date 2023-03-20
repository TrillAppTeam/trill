import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
    required this.user,
    this.radius = 32,
    this.fontSize = 20,
    this.borderWidth = 2,
  }) : super(key: key);

  final User user;
  final double radius;
  final double fontSize;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF3FBCF4),
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFF111318),
        child: user.profilePicURL.isNotEmpty
            ? CircleAvatar(
                radius: radius,
                backgroundColor: const Color(0xFF111318),
                backgroundImage: NetworkImage(
                  user.profilePicURL,
                ),
              )
            : Center(
                child: Text(
                  user.username.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
