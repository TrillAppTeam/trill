import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/static_rating_bar.dart';

class DetailedReviewTile extends StatelessWidget {
  DetailedReviewTile({
    Key? key,
    required this.review,
    required this.onLiked,
    this.clickableUsername = true,
  }) : super(key: key);

  final Review review;
  final void Function(bool) onLiked;
  bool clickableUsername;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // todo: set album id
              builder: (context) => const AlbumDetailsScreen(
                albumID: '3xFXzriygSZ63hRXMHdZti',
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Image.network(
            'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
            width: 60,
            height: 60,
          ),
        ),
      ),
      title: StaticRatingBar(rating: review.rating, size: 20),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumDetailsScreen(
                    albumID: review.albumID,
                  ),
                ),
              );
            },
            child: Row(
              children: const [
                Text(
                  'Harry\'s House',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFEEEEEE),
                  ),
                ),
                Text(' - Harry Styles'),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (clickableUsername) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          username: review.username,
                        ),
                      ),
                    );
                  }
                },
                child: Row(
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
                  ],
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
            key: ValueKey('likeButton_${review.reviewID}'),
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
