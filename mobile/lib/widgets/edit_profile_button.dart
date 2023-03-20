import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/edit_profile.dart';

class EditProfileButton extends StatefulWidget {
  final User user;
  final Function onUserChanged;

  const EditProfileButton({
    super.key,
    required this.user,
    required this.onUserChanged,
  });

  @override
  _EditProfileButtonState createState() => _EditProfileButtonState();
}

class _EditProfileButtonState extends State<EditProfileButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProfileScreen(
              initialUser: widget.user,
              onUserChanged: () {
                widget.onUserChanged();
              },
            ),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 28,
        decoration: BoxDecoration(
          color: const Color(0xFF374151),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(
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
