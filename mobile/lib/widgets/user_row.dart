import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';

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
          // should be circle profile pic
          Image.network(
              'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
              width: 80,
              height: 80),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user.username,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.bio,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
