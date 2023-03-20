import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/widgets/profile_pic.dart';
import 'package:trill/widgets/rating_bar.dart';

class NewReview extends StatefulWidget {
  NewReview({
    Key? key,
    required this.user,
    required this.onCreate,
  }) : super(key: key);

  final User user;
  final void Function(int, String) onCreate;

  @override
  State<NewReview> createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  int _editingRating = 0;
  final TextEditingController _reviewTextController = TextEditingController();

  @override
  void dispose() {
    _reviewTextController.dispose();
    super.dispose();
  }

  void _saveEditing() {
    widget.onCreate(_editingRating, _reviewTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ProfilePic(
        user: widget.user,
        radius: 24,
        fontSize: 18,
      ),
      title: ReviewRatingBar(
        rating: 0,
        size: 20,
        isStatic: false,
        onRatingUpdate: (rating) {
          _editingRating = ((rating * 2).ceil().toInt());
        },
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildText(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _saveEditing,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildText() {
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
  }
}
