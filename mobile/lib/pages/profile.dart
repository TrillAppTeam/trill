import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/api/users.dart';
import 'package:trill/constants.dart';
import 'package:trill/widgets/albums_row.dart';
import 'package:trill/widgets/detailed_review_tile.dart';
import 'package:trill/widgets/follow_button.dart';
import 'package:trill/widgets/follow_user_button.dart';
import 'package:trill/widgets/ratings_row.dart';

import 'package:trill/widgets/review_row.dart';
import 'package:trill/widgets/review_tile.dart';
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

  String _selectedSort = 'popular';
  List<Review>? _reviews;

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
              backgroundColor: const Color(0xFF1A1B29),
              appBar: _isLoggedIn ? null : AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildUserDetails(),
                    const SizedBox(height: 15),
                    _buildFollows(),
                    const SizedBox(height: 15),
                    _buildUserStats(),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FutureBuilder<List<SpotifyAlbum>?>(
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
                    ),
                    const SizedBox(height: 15),
                    const Divider(
                      color: Colors.grey,
                      height: 2,
                      thickness: 2,
                    ),
                    const SizedBox(height: 15),
                    _buildReviewDetails(),
                    _buildReviews(),
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
        SizedBox(
          width: (_isLoggedIn ? 30 : 20),
        ),
        FollowButton(
          username: widget.username,
          followType: FollowType.follower,
        ),
        SizedBox(
          width: (_isLoggedIn ? 0 : 20),
        ),
        if (!_isLoggedIn)
          FollowUserButton(
            username: _user.username,
            isFollowing: true,
          ),
      ],
    );
  }

  Widget _buildUserStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  Widget _buildReviewDetails() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: _selectedSort,
                items: const [
                  DropdownMenuItem(
                    value: 'popular',
                    child: Text('Most liked'),
                  ),
                  DropdownMenuItem(
                    value: 'newest',
                    child: Text('Newest'),
                  ),
                  DropdownMenuItem(
                    value: 'oldest',
                    child: Text('Oldest'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedSort = value!;
                    _buildReviews();
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF3FBCF4),
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                  color: Color(0xFF3FBCF4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                underline: Container(
                  height: 2,
                  color: const Color(0xFF3FBCF4),
                ),
                dropdownColor: const Color(0xFF1A1B29),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final review = _reviews![index];
        return Column(
          children: [
            index == 0
                ? const SizedBox(height: 10)
                : const Divider(
                    color: Colors.grey,
                  ),
            DetailedReviewTile(
              review: review,
              onLiked: (isLiked) {
                setState(() {
                  review.isLiked = isLiked;
                });
              },
              isMyReview: _isLoggedIn,
              onUpdated: _isLoggedIn
                  ? (rating, reviewText) async {
                      final success = await createOrUpdateReview(
                          review.albumID, rating, reviewText);
                      if (success) {
                        setState(() {
                          review.rating = rating;
                          review.reviewText = reviewText;
                        });
                      }
                    }
                  : (rating, reviewText) {},
            ),
          ],
        );
      },
      itemCount: _reviews!.length,
      shrinkWrap: true,
    );
  }

  Widget _buildReviewListWithLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoReviewsMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No reviews yet',
          style: TextStyle(
            color: Color(0xFF3FBCF4),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildReviews() {
    return FutureBuilder<List<Review>?>(
      future: getReviews(_selectedSort, _user.username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            (_reviews == null || _reviews!.isEmpty)) {
          return _buildReviewListWithLoading();
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _reviews = snapshot.data!;
          return _buildReviewList();
        }
        return _buildNoReviewsMessage();
      },
    );
  }
}
