import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/api/users.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/lists/follows.dart';
import 'package:trill/widgets/albums_row.dart';
import 'package:trill/widgets/follow_button.dart';
import 'package:trill/widgets/follow_user_button.dart';
import 'package:trill/widgets/ratings_row.dart';

import 'package:trill/widgets/review_row.dart';
import 'package:trill/widgets/static_rating_bar.dart';
import 'loading_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({
    super.key,
    required this.username,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late SharedPreferences _prefs;

  late PublicUser _user;
  bool _isLoggedIn = false;

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

    _prefs = await SharedPreferences.getInstance();
    String loggedInUser = _prefs.getString('username') ?? "";
    _isLoggedIn = loggedInUser == widget.username;

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
              appBar: _isLoggedIn ? null : AppBar(),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUserDetails(),
                    const SizedBox(height: 15),
                    _buildFollows(),
                    const SizedBox(height: 15),
                    _buildUserStats(),
                    const SizedBox(height: 15),
                    FutureBuilder<List<SpotifyAlbum>?>(
                      future: getFavoriteAlbums(_user.username),
                      builder: (context, snapshot) {
                        return AlbumsRow(
                          title: _isLoggedIn
                              ? 'Your Favorite Albums'
                              : '${_user.nickname}\'s Favorite Albums',
                          albums: snapshot.hasData ? snapshot.data! : [],
                          emptyText: _isLoggedIn
                              ? 'No favorite albums yet. Add your favorite albums to display on your profile!'
                              : 'No favorite albums yet',
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      color: Colors.grey,
                      height: 2,
                      thickness: 2,
                    ),
                    const SizedBox(height: 15),
                    FutureBuilder<List<Review>?>(
                      future: getReviews('newest', _user.username),
                      builder: (context, snapshot) {
                        return RatingsRow(
                          title: _isLoggedIn
                              ? 'Your Recent Ratings'
                              : '${_user.nickname}\'s Recent Ratings',
                          reviews: snapshot.hasData ? snapshot.data! : [],
                          emptyText: _isLoggedIn
                              ? 'No reviews yet. Add your first review to display it on your profile!'
                              : 'No reviews yet',
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Text(
                            _isLoggedIn
                                ? 'Your Recent Reviews'
                                : '${_user.nickname}\'s Recent Reviews',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Text(
                          "See All",
                          style: TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ReviewRow(
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
                    ReviewRow(
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
          );
  }

  Widget _buildUserDetails() {
    return Column(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage("images/gerber.jpg"),
          radius: 40.0,
        ),
        Text(
          _user.nickname,
          style: const TextStyle(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text('@${_user.username}'),
        const SizedBox(height: 5),
        Text(
          _user.bio,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFollows() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FollowButton(
          username: widget.username,
          followType: FollowType.following,
        ),
        SizedBox(width: (_isLoggedIn ? 30 : 20)),
        FollowButton(
          username: widget.username,
          followType: FollowType.follower,
        ),
        SizedBox(width: (_isLoggedIn ? 0 : 20)),
        if (!_isLoggedIn) const FollowUserButton(isFollowing: true)
      ],
    );
  }

  Widget _buildUserStats() {
    return Row(
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
            Text("Albums This Month", style: TextStyle(fontSize: 11))
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
    );
  }
}
