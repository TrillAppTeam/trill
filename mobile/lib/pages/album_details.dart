import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/album_details_header.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';

class AlbumDetailsScreen extends StatefulWidget {
  // todo: refresh album and reviews with gesture
  final String albumID;

  AlbumDetailsScreen({required this.albumID});

  @override
  _AlbumDetailsScreenState createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  late SpotifyAlbum _album;
  List<Review>? _reviews;
  String _selectedSort = 'popular';

  bool _isLoading = true;

  late Future<PaletteGenerator> _paletteGenerator;
  Color _appBarColor = Color(0xFF1F1D36);

  final _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
    // _paletteGenerator = _generatePalette();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAlbumDetails() async {
    final album = await getSpotifyAlbum(widget.albumID);
    setState(() {
      _album = album!;
      _isLoading = false;
    });
  }

  Future<PaletteGenerator> _generatePalette() async {
    return await PaletteGenerator.fromImageProvider(
      NetworkImage(
          'https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015'),
      size: Size(
        _album.images[0].width.toDouble(),
        _album.images[0].height.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // todo: proper loading screen
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildBackdrop(context),
                _buildAlbumDetails(),
                _buildReviewDetails(),
                // todo: add dropdown to sort reviews
                _buildReviews(),
              ],
            ),
          );
  }

  Widget _buildBackdrop(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: AlbumDetailsHeader(
        minHeight: 50.0,
        maxHeight: 200.0,
        album: _album,
      ),
    );
  }

  Widget _buildAlbumDetails() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _album.artists[0].name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Released: ${_album.releaseDate}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              _album.label,
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewDetails() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reviews:',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedSort,
                  items: [
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final review = _reviews![index];
          return Column(
            children: [
              ListTile(
                leading: FutureBuilder(
                  // todo: get user's pfp
                  // future: getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        // todo: change image to user's pfp, snapshot.data
                        backgroundImage: NetworkImage(
                          _album.images[0].url,
                        ),
                      );
                    } else {
                      // todo: change to actual placeholder
                      return CircleAvatar(
                        backgroundImage: NetworkImage(
                          _album.images[0].url,
                        ),
                      );
                    }
                  },
                ),
                title: RatingBar.builder(
                  initialRating: review.rating / 2,
                  minRating: 1,
                  allowHalfRating: true,
                  itemSize: 20,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Color(0xFFEEEEEE),
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          review.username,
                          style: TextStyle(
                            color: Color(0xFF3FBCF4),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          timeago.format(
                            DateTime.now().subtract(
                              DateTime.now().difference(review.createdAt),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    if (review.reviewText.isNotEmpty)
                      Column(
                        children: [
                          ExpandableText(
                            text: review.reviewText,
                            maxLines: 5,
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    LikeButton(
                      reviewID: review.reviewID,
                      isLiked: review.isLiked,
                      numLikes: review.likes,
                      onLiked: (isLiked) {
                        setState(() {
                          review.isLiked = isLiked;
                        });
                      },
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          );
        },
        childCount: _reviews!.length,
      ),
    );
  }

  Widget _buildReviewListWithLoading() {
    return SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNoReviewsMessage() {
    return SliverToBoxAdapter(
      child: Center(
        child: Text('No reviews yet'),
      ),
    );
  }

  Widget _buildReviews() {
    return FutureBuilder<List<Review>>(
      // change albumID
      future: getAlbumReviews(_selectedSort, "testingupdate"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            _reviews == null) {
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
