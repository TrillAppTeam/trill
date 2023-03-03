import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/widgets/album_details_header.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';

class AlbumDetailsScreen extends StatefulWidget {
  // todo: refresh album and reviews with gesture
  final SpotifyAlbum album;
  final List<Review> reviews;

  AlbumDetailsScreen({required this.album, required this.reviews});

  @override
  _AlbumDetailsScreenState createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  late Future<PaletteGenerator> _paletteGenerator;
  Color _appBarColor = Color(0xFF1F1D36);

  final _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _paletteGenerator = _generatePalette();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<PaletteGenerator> _generatePalette() async {
    return await PaletteGenerator.fromImageProvider(
      NetworkImage(
          'https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015'),
      size: Size(
        widget.album.images[0].width.toDouble(),
        widget.album.images[0].height.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildBackdrop(context),
          _buildAlbumDetails(),
          _buildReviewDetails(),
          // todo: add dropdown to sort reviews
          _buildReviewList(),
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
        album: widget.album,
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
              widget.album.artists[0].name,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Released: ${widget.album.releaseDate}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.album.label,
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
            Text(
              'Reviews:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
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
          final review = widget.reviews[index];
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
                          widget.album.images[0].url,
                        ),
                      );
                    } else {
                      // todo: change to actual placeholder
                      return CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.album.images[0].url,
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
                    // todo: update when api is changed
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
        childCount: widget.reviews.length,
      ),
    );
  }
}
