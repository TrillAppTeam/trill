import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/widgets/profile_pic.dart';

class UserRow extends StatelessWidget {
  const UserRow({
    Key? key,
    required User user,
  })  : _user = user,
        super(key: key);

  final User _user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ProfilePic(user: _user),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${_user.username}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      _user.nickname,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (_user.bio.isNotEmpty)
                      Text(
                        '•',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Text(
                      _user.bio,
                      style: TextStyle(color: Colors.grey[400]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
