import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/static_rating_bar.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
    required this.review,
    required this.onLiked,
  }) : super(key: key);

  final Review review;
  final void Function(bool) onLiked;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
        ),
      ),
      title: StaticRatingBar(rating: review.rating, size: 20),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                review.username,
                style: const TextStyle(
                  color: Color(0xFF3FBCF4),
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                timeago.format(
                  DateTime.now().subtract(
                    DateTime.now().difference(review.createdAt),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                // ${timeago.format(DateTime.now().subtract(DateTime.now().difference(review.updatedAt)))}
                review.updatedAt != review.createdAt ? '(edited)' : "",
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (review.reviewText.isNotEmpty)
            Column(
              children: [
                ExpandableText(
                  text: review.reviewText,
                  maxLines: 5,
                ),
                const SizedBox(height: 8),
              ],
            ),
          LikeButton(
            reviewID: review.reviewID,
            isLiked: review.isLiked,
            numLikes: review.likes,
            onLiked: onLiked,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
