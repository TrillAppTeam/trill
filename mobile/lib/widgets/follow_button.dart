import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/lists/follows.dart';

class FollowButton extends StatefulWidget {
  final String username;
  final FollowType followType;

  const FollowButton({
    super.key,
    required this.username,
    required this.followType,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: FutureBuilder<List<User>?>(
          future: widget.followType == FollowType.following
              ? getFollowing(widget.username)
              : getFollowers(widget.username),
          builder: (context, snapshot) {
            safePrint(snapshot.connectionState);
            safePrint(snapshot.hasData);
            if (snapshot.hasData) {
              String followCount = snapshot.data!.length.toString();
              return RichText(
                text: TextSpan(
                  text: widget.followType == FollowType.following
                      ? 'Following: $followCount'
                      : 'Followers: $followCount',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    // should make the tap on the actual button and not the text
                    ..onTap = () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FollowsScreen(
                              username: widget.username,
                              followType: widget.followType,
                            ),
                          ),
                        ),
                ),
              );
            } else {
              return const Text('Loading');
            }
          },
        ),
      ),
    );
  }
}
