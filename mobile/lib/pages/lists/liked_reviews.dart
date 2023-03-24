import 'package:flutter/material.dart';
import '../../api/reviews.dart';
import '../../widgets/detailed_review_tile.dart';

class LikedReviewsScreen extends StatefulWidget {
  const LikedReviewsScreen({super.key});

  @override
  State<LikedReviewsScreen> createState() => _LikedReviewsScreenState();
}

class _LikedReviewsScreenState extends State<LikedReviewsScreen> {
  bool _isLoading = false;
  List<DetailedReview>? _reviews;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future<void>.value(null),
      backgroundColor: const Color(0xFF1A1B29),
      color: const Color(0xFF3FBCF4),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1B29),
        appBar: AppBar(
          title: const Text('Liked Reviews'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildReviews(),
        ),
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
          'No reviews yet.',
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
      future: getReviews('popular'),
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
