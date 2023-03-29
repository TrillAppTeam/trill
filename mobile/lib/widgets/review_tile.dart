import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/profile_pic.dart';
import 'package:trill/widgets/rating_bar.dart';

class ReviewTile extends StatefulWidget {
  ReviewTile({
    Key? key,
    required this.review,
    required this.onLiked,
    this.isMyReview = false,
    this.onUpdate,
    this.onDelete,
  }) : super(key: key);

  final Review review;
  final void Function(bool) onLiked;

  bool isMyReview;
  final void Function(int, String)? onUpdate;
  final Function? onDelete;

  @override
  State<ReviewTile> createState() => _ReviewTileState();
}

class _ReviewTileState extends State<ReviewTile> {
  bool _isEditing = false;
  int _editingRating = 0;

  TextEditingController? _reviewTextController;

  @override
  void initState() {
    super.initState();
    if (widget.isMyReview) {
      _reviewTextController =
          TextEditingController(text: widget.review.reviewText);
    }
  }

  @override
  void dispose() {
    if (_reviewTextController != null) {
      _reviewTextController!.dispose();
    }
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _editingRating = widget.review.rating;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveEditing() {
    widget.onUpdate!(_editingRating, _reviewTextController!.text);
    setState(() {
      _isEditing = false;
    });
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case 'edit':
        _startEditing();
        break;
      case 'delete':
        widget.onDelete!();
        break;
      case 'report':
        safePrint('no');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ListTile(
        title: _buildTitle(),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRatingBar(),
                const SizedBox(width: 10),
                _buildReviewDate(),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildText(),
                  _buildBottom(),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildUserInfo(context),
        _buildDropdown(),
      ],
    );
  }

  SizedBox _buildDropdown() {
    return SizedBox(
      width: 30,
      child: PopupMenuButton<String>(
        onSelected: (value) => _handleMenuClick(value),
        itemBuilder: (context) => [
          if (widget.isMyReview)
            PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: const [
                  Icon(
                    Icons.edit_outlined,
                    color: Color(0xFFCCCCCC),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.isMyReview)
            PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: const [
                  Icon(
                    Icons.delete_outline,
                    color: Color(0xFFAA2222),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Color(0xFFAA2222),
                    ),
                  ),
                ],
              ),
            ),
          if (!widget.isMyReview)
            PopupMenuItem<String>(
              value: 'report',
              child: Row(
                children: const [
                  Icon(
                    Icons.flag_outlined,
                    color: Color(0xFFAA2222),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Report',
                    style: TextStyle(
                      color: Color(0xFFAA2222),
                    ),
                  ),
                ],
              ),
            ),
        ],
        color: const Color(0xFF222331),
        elevation: 3,
        icon: const Icon(
          Icons.more_vert,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRatingBar() {
    if (_isEditing) {
      return ReviewRatingBar(
        rating: widget.review.rating,
        size: 20,
        isStatic: false,
        onRatingUpdate: (rating) {
          _editingRating = ((rating * 2).ceil().toInt());
        },
      );
    } else {
      return ReviewRatingBar(
        rating: widget.review.rating,
        size: 20,
      );
    }
  }

  Widget _buildUserInfo(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isMyReview) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                username: widget.review.user.username,
              ),
            ),
          );
        }
      },
      child: Row(
        children: [
          ProfilePic(
            user: widget.review.user,
            radius: 24,
            fontSize: 17,
            borderWidth: 1,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.review.user.nickname,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '@${widget.review.user.username}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildReviewDate() {
    return Row(
      children: [
        Text(
          timeago.format(
            DateTime.now().subtract(
              DateTime.now().difference(widget.review.createdAt),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          // ${timeago.format(DateTime.now().subtract(DateTime.now().difference(review.updatedAt)))}
          (widget.review.updatedAt.difference(widget.review.createdAt)).inSeconds.abs() > 3 ? '(edited)' : "",
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    if (_isEditing) {
      return Column(
        children: [
          const SizedBox(height: 5),
          TextFormField(
            controller: _reviewTextController,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey[600]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey[600]!,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 15,
              letterSpacing: .2,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else if (widget.review.reviewText.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(height: 5),
          ExpandableText(
            text: widget.review.reviewText,
            maxLines: 5,
          ),
          const SizedBox(height: 10),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildBottom() {
    if (_isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _cancelEditing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _saveEditing,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            ),
            child: const Text('Save'),
          ),
        ],
      );
    } else {
      return LikeButton(
        key: ValueKey('likeButton_${widget.review.reviewID}'),
        reviewID: widget.review.reviewID,
        isLiked: widget.review.isLiked,
        numLikes: widget.review.likes,
        onLiked: widget.onLiked,
      );
    }
  }
}
