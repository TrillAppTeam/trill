import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/profile_pic.dart';
import 'package:trill/widgets/rating_bar.dart';

class DetailedReviewTile extends StatefulWidget {
  DetailedReviewTile({
    Key? key,
    required this.review,
    required this.onLiked,
    this.isMyReview = false,
    this.onUpdate,
    this.onDelete,
  }) : super(key: key);

  final DetailedReview review;
  final void Function(bool) onLiked;

  bool isMyReview;
  final void Function(int, String)? onUpdate;
  final Function? onDelete;

  @override
  State<DetailedReviewTile> createState() => _DetailedReviewTileState();
}

class _DetailedReviewTileState extends State<DetailedReviewTile> {
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
    return ListTile(
      leading: _buildAlbumImage(context),
      trailing: SizedBox(
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
          color: const Color(0xFF1A1B29),
          icon: const Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
        ),
      ),
      title: _buildRatingBar(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _buildAlbumDetails(context),
          const SizedBox(height: 5),
          _buildUserRow(context),
          const SizedBox(height: 8),
          _buildText(),
          _buildBottom(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  InkWell _buildAlbumImage(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(
              albumID: widget.review.albumID,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image.network(
          widget.review.album.images[0].url,
          width: 60,
          height: 60,
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

  InkWell _buildAlbumDetails(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(
              albumID: widget.review.albumID,
            ),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              widget.review.album.name,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFEEEEEE),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                widget.review.album.artists
                    .map((artist) => artist.name)
                    .join(", "),
                style: const TextStyle(
                  color: Color(0xFFCCCCCC),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                DateFormat('yyyy').format(widget.review.album.releaseDate),
                style: const TextStyle(
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildUserRow(BuildContext context) {
    return Row(
      children: [
        _buildUserDetails(context),
        const SizedBox(width: 5),
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
          widget.review.updatedAt != widget.review.createdAt ? '(edited)' : "",
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  InkWell _buildUserDetails(BuildContext context) {
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
            radius: 10,
            fontSize: 10,
            borderWidth: 1,
          ),
          const SizedBox(width: 5),
          Text(
            widget.review.user.username,
            style: const TextStyle(
              color: Color(0xFF3FBCF4),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    if (_isEditing) {
      return Column(
        children: [
          const SizedBox(height: 5),
          TextFormField(
            controller: _reviewTextController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else if (widget.review.reviewText.isNotEmpty) {
      return Column(
        children: [
          ExpandableText(
            text: widget.review.reviewText,
            maxLines: 5,
          ),
          const SizedBox(height: 8),
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
