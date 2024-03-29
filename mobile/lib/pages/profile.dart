import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/api/users.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/edit_profile.dart';
import 'package:trill/pages/lists/follows.dart';
import 'package:trill/widgets/albums_row.dart';
import 'package:trill/widgets/detailed_review_tile.dart';
import 'package:trill/widgets/edit_profile_button.dart';
import 'package:trill/widgets/follow_button.dart';
import 'package:trill/widgets/follow_user_button.dart';
import 'package:trill/widgets/profile_pic.dart';

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
  late DetailedUser _user;

  String? _loggedInUsername;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  String _selectedSort = 'popular';
  List<DetailedReview>? _reviews;

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
    _loggedInUsername = loggedInUser;
    _isLoggedIn = loggedInUser == widget.username;

    final user = await getDetailedUser(widget.username);

    setState(() {
      _user = user!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B29),
      appBar: _isLoggedIn ? null : AppBar(),
      body: _isLoading
          ? const LoadingScreen()
          : GestureDetector(
              onTap: () {
                final FocusScopeNode currentScope = FocusScope.of(context);
                if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              child: RefreshIndicator(
                onRefresh: _fetchUserDetails,
                backgroundColor: const Color(0xFF1A1B29),
                color: const Color(0xFF3FBCF4),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildUserInfo(),
                      Divider(
                        color: Colors.grey[700],
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: FutureBuilder<List<SpotifyAlbum>?>(
                          future: getFavoriteAlbums(_user.username),
                          builder: (context, snapshot) {
                            return AlbumsRow(
                              title: _isLoggedIn
                                  ? 'My Favorite Albums'
                                  : '${_user.nickname}\'s Favorite Albums',
                              albums: snapshot.hasData ? snapshot.data! : [],
                              emptyText: _isLoggedIn
                                  ? 'No favorite albums yet. Add your favorite albums to display on your profile!'
                                  : 'No favorite albums yet.',
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Colors.grey[700],
                      ),
                      _buildReviewDetails(),
                      _buildReviews(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Padding _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 15, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (_isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          initialUser: _user,
                          onUserChanged: () async {
                            await _fetchUserDetails();
                          },
                        ),
                      ),
                    );
                  }
                },
                child: ProfilePic(
                  user: _user,
                  radius: 40,
                  fontSize: 24,
                ),
              ),
              const SizedBox(width: 15),
              _buildUserStats(),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserDetails(),
              const SizedBox(height: 10),
              !_isLoggedIn
                  ? FollowUserButton(
                      username: _user.username,
                      isFollowing: _user.requestorFollows,
                      onFollowed: (followed) {
                        if (followed) {
                          setState(() {
                            _user.followers += 1;
                          });
                        } else {
                          setState(() {
                            _user.followers -= 1;
                          });
                        }
                      },
                    )
                  : EditProfileButton(
                      user: _user,
                      onUserChanged: () async {
                        await _fetchUserDetails();
                      },
                    ),
            ],
          ),
          if (_user.bio.isNotEmpty) const SizedBox(height: 12),
          if (_user.bio.isNotEmpty)
            Wrap(
              children: [
                Text(
                  _user.bio,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                    letterSpacing: .2,
                    height: 1.3,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildUserDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              _user.nickname,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              ),
            ),
            const SizedBox(width: 10),
            if (!_isLoggedIn && _user.followsRequestor)
              Text(
                '•  Follows you',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          '@${_user.username}',
          style: TextStyle(
            color: Colors.grey[400],
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: .3,
          ),
        ),
      ],
    );
  }

  Widget _buildUserStats() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          UserStatButton(
            name: 'Albums',
            stat: _user.reviewCount,
            onTap: () {},
          ),
          UserStatButton(
            name: 'Following',
            stat: _user.following,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowsScreen(
                    username: _user.username,
                    loggedInUsername: _loggedInUsername ?? '',
                    followType: FollowType.following,
                  ),
                ),
              );
            },
          ),
          UserStatButton(
            name: 'Followers',
            stat: _user.followers,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FollowsScreen(
                    username: _user.username,
                    loggedInUsername: _loggedInUsername ?? '',
                    followType: FollowType.follower,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDetails() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isLoggedIn ? 'My Reviews' : '${_user.nickname}\'s Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: .6,
                  color: Colors.grey[300],
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
                elevation: 3,
                style: const TextStyle(
                  color: Color(0xFF3FBCF4),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                underline: Container(
                  height: 2,
                  color: const Color(0xFF3FBCF4),
                ),
                dropdownColor: const Color(0xFF222331),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey[700],
        );
      },
      itemBuilder: (context, index) {
        final review = _reviews![index];
        return DetailedReviewTile(
          review: review,
          onLiked: (isLiked) {
            setState(() {
              review.isLiked = isLiked;
            });
          },
          isMyReview: _isLoggedIn,
          onUpdate: _isLoggedIn
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
          onDelete: () async {
            final success = await deleteReview(
              review.albumID,
            );
            if (success) {
              setState(() {
                _reviews!.removeAt(index);
              });
            }
          },
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
    return FutureBuilder<List<DetailedReview>?>(
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
