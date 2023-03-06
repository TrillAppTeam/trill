import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/api/users.dart';

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
                                future: getFollowers(),
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
                                          ..onTap = () => Navigator.pushNamed(
                                                context,
                                                '/followers',
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
                                future: getFollowing(),
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
                                          ..onTap = () => Navigator.pushNamed(
                                              context, '/following'),
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
                              Text("Albums This Year",
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
                      const Center(
                        child: Text(
                          "Matthew's Favorite Albums",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        color: const Color(0xFF392B3A),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "This Works For Like 80% Of Titles",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Dierks Bentley - 2003",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: const [
                                      Text(
                                        "Reviewed by ",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Text(
                                        "Matthew ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "What was I thinkin'? Frederick Dierks Bentley Password cracking is a term used to describe the penetration of a network, system, or resource"
                                    "with or without the use of tools to ulock a resource that has been secured with a password."
                                    " Password cracking tools may seem like powerful decryptors, but in reality are little more than"
                                    "    fast, sophisticated guessing machines.",
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.favorite_outline_outlined,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "33 likes",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Image.asset(
                                "images/DierksBentleyTest.jpg",
                                width: 120,
                                height: 120,
                              ),
                            ),
                          ],
                        ),
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
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        color: const Color(0xFF392B3A),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Lucy In The Sky With Diamonds And Other Words That Make This Title Longer And Longer",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    "Dierks Bentley - 2003",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: const [
                                      Text(
                                        "Reviewed by ",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        "Matthew ",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "What was I thinkin'? Frederick Dierks Bentley Password cracking is a term used to describe the penetration of a network, system, or resource"
                                    "with or without the use of tools to ulock a resource that has been secured with a password."
                                    " Password cracking tools may seem like powerful decryptors, but in reality are little more than"
                                    "    fast, sophisticated guessing machines.",
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.favorite_outline_outlined,
                                        size: 20,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "33 likes",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                              child: Image.asset(
                                "images/DierksBentleyTest.jpg",
                                width: 120,
                                height: 120,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
