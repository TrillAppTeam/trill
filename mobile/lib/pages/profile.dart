import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/lists/follows.dart';

import 'package:trill/widgets/review.dart';
import 'loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;

  const ProfileScreen({super.key, this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late PublicUser _user;
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
    final user = await getPublicUser(widget.username);
    setState(() {
      _user = user!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : RefreshIndicator(
            onRefresh: _fetchUserDetails,
            backgroundColor: const Color(0xFF1A1B29),
            color: const Color(0xFF3FBCF4),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 30.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("images/gerber.jpg"),
                        radius: 40.0,
                      ),
                      Column(
                        children: [
                          Text(
                            _user.nickname,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('@${_user.username}'),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _user.bio,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Spacer(),
                          Container(
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
                              child: FutureBuilder<Follow?>(
                                future: getFollowing(_user.username),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    String followingCount =
                                        snapshot.data!.users.length.toString();
                                    return RichText(
                                      text: TextSpan(
                                        text: 'Following: $followingCount',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowsScreen(
                                                    username: _user.username,
                                                    followType:
                                                        FollowType.following,
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
                          ),
                          const Spacer(flex: 2),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFBC6AAB), width: 1),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: FutureBuilder<Follow?>(
                                future: getFollowers(_user.username),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    String followerCount =
                                        snapshot.data!.users.length.toString();
                                    return RichText(
                                      text: TextSpan(
                                        text: 'Followers: $followerCount',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowsScreen(
                                                    username: _user.username,
                                                    followType:
                                                        FollowType.follower,
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
                          ),
                          const Spacer()
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "455",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Total Albums",
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "3",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFBC6AAB),
                                    fontWeight: FontWeight.bold),
                              ),
                              Text("Albums This Month",
                                  style: TextStyle(fontSize: 11))
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "30",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Listen Laters",
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "5",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFBC6AAB),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Reviews",
                                style: TextStyle(fontSize: 11),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Matthew's Favorite Albums",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65,
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65,
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65,
                          ),
                          const Spacer(),
                          Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65,
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Divider(
                        color: Colors.grey,
                        height: 2,
                        thickness: 2,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: const [
                          Text(
                            "Matthew's Recent Ratings",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            "See All",
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Column(
                            children: [
                              Image.asset('images/DierksBentleyTest.jpg',
                                  width: 65),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Image.asset('images/DierksBentleyTest.jpg',
                                  width: 65),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Image.asset('images/DierksBentleyTest.jpg',
                                  width: 65),
                              const SizedBox(height: 10),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(children: [
                            Image.asset('images/DierksBentleyTest.jpg',
                                width: 65),
                            const SizedBox(height: 10),
                            Row(
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                                Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: const [
                          Text(
                            "Matthew's Recent Reviews",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            "See All",
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Review(
                        title:
                            'Lucy In The Sky With Diamonds And Other Words That Make This Title Longer And Longer',
                        artist: 'Dierks Bentley',
                        releaseYear: '2003',
                        reviewerName: 'Matthew',
                        starRating: 5,
                        reviewId: 69,
                        reviewText:
                            'What was I thinkin\'? Frederick Dierks Bentley Password cracking is a term used to describe the penetration of a network, system, or resourcewith or without the use of tools to unlock a resource that has been secured with a password',
                        likeCount: 33,
                        imageUrl: 'images/DierksBentleyTest.jpg',
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: const [
                          Text(
                            "Matthew's Most Popular Reviews",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Review(
                        title:
                            'Lucy In The Sky With Diamonds And Other Words That Make This Title Longer And Longer',
                        artist: 'Dierks Bentley',
                        releaseYear: '2003',
                        reviewerName: 'Matthew',
                        starRating: 9,
                        reviewId: 69,
                        reviewText:
                            'What was I thinkin\'? Frederick Dierks Bentley Password cracking is a term used to describe the penetration of a network, system, or resourcewith or without the use of tools to unlock a resource that has been secured with a password',
                        likeCount: 33,
                        imageUrl: 'images/DierksBentleyTest.jpg',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
