import 'package:flutter/material.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/widgets/static_rating_bar.dart';

class RatingsRow extends StatefulWidget {
  final String title;
  final List<Review> reviews;
  String? emptyText;

  RatingsRow({
    Key? key,
    required this.title,
    required this.reviews,
    this.emptyText,
  }) : super(key: key);

  @override
  State<RatingsRow> createState() => _RatingsRowState();
}

class _RatingsRowState extends State<RatingsRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        widget.reviews.isEmpty
            ? Text(
                widget.emptyText ?? '',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...widget.reviews.take(4).map(
                    (Review review) {
                      return Column(
                        children: [
                          Image.network(
                            // todo: need image
                            'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
                            width: 75,
                          ),
                          const SizedBox(height: 10),
                          StaticRatingBar(rating: review.rating, size: 12),
                        ],
                      );
                    },
                  ),
                  ...List.filled(
                    4 - widget.reviews.length.clamp(0, 4),
                    Container(width: 75),
                  ),
                ],
              ),
      ],
    );
  }
}
