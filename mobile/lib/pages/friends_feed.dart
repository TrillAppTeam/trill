import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/detailed_review_tile.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/review_tile.dart';
import 'package:trill/widgets/static_rating_bar.dart';

class FriendsFeedScreen extends StatefulWidget {
  const FriendsFeedScreen({super.key});

  @override
  State<FriendsFeedScreen> createState() => _FriendsFeedScreenState();
}

class _FriendsFeedScreenState extends State<FriendsFeedScreen> {
  late List<Review> _reviews;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() {
      _isLoading = true;
    });
    final reviews = await getFriendsFeed();
    setState(() {
      _reviews = reviews ?? [];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : RefreshIndicator(
            onRefresh: _fetchReviews,
            backgroundColor: const Color(0xFF1A1B29),
            color: const Color(0xFF3FBCF4),
            child: ListView.builder(
              itemBuilder: (context, index) {
                final review = _reviews[index];
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
                    ),
                  ],
                );
              },
              itemCount: _reviews.length,
            ),
          );
  }
}
