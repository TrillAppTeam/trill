import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:trill/api/reviews.dart';

class StaticRatingBar extends StatelessWidget {
  const StaticRatingBar({
    Key? key,
    required this.rating,
    required this.size,
  }) : super(key: key);

  final int rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating / 2,
      minRating: 1,
      allowHalfRating: true,
      itemSize: size,
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.white,
      ),
      onRatingUpdate: (rating) {},
      ignoreGestures: true,
    );
  }
}
