import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewRatingBar extends StatelessWidget {
  const ReviewRatingBar({
    Key? key,
    required this.rating,
    required this.size,
    this.isStatic = true,
    this.onRatingUpdate,
  }) : super(key: key);

  final int rating;
  final double size;

  final bool isStatic;
  final void Function(double)? onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating / 2,
      minRating: 1,
      allowHalfRating: true,
      itemSize: size,
      updateOnDrag: !isStatic,
      unratedColor: isStatic ? Colors.grey[800] : Colors.grey,
      itemBuilder: (context, index) {
        return const Icon(
          Icons.star,
          color: Color(0xFF3FBCF4),
        );
      },
      onRatingUpdate: isStatic ? (rating) {} : onRatingUpdate!,
      ignoreGestures: isStatic,
    );
  }
}
