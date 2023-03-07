import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/static_rating_bar.dart';

class DetailedReviewTile extends StatelessWidget {
  const DetailedReviewTile({
    Key? key,
    required this.review,
    required this.onLiked,
  }) : super(key: key);

  final Review review;
  final void Function(bool) onLiked;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
        width: 60,
        height: 60,
      ),
      title: Row(
        children: const [
          Text(
            'Harry\'s House',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(' - Harry Styles'),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          StaticRatingBar(rating: review.rating, size: 20),
          const SizedBox(height: 5),
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
                ),
                radius: 10,
              ),
              const SizedBox(width: 5),
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
