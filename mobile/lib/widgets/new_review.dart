import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/widgets/rating_bar.dart';

class NewReview extends StatefulWidget {
  const NewReview({
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
  bool _isEditing = false;
  int _editingRating = 0;
  final TextEditingController _reviewTextController = TextEditingController();
  final FocusNode _reviewFocusNode = FocusNode();

  @override
  void dispose() {
    _reviewTextController.dispose();
    _reviewFocusNode.dispose();
    super.dispose();
  }

  void _cancelEditing() {
    _reviewTextController.clear();
    _reviewFocusNode.unfocus();
    _editingRating = 0;
    setState(() {
      _isEditing = false;
    });
  }

  void _saveEditing() {
    widget.onCreate(_editingRating, _reviewTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            'Share your thoughts on this album:',
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              letterSpacing: .4,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ReviewRatingBar(
                rating: _isEditing ? _editingRating : 0,
                size: 20,
                isStatic: false,
                onRatingUpdate: (rating) {
                  _editingRating = ((rating * 2).ceil().toInt());
                  if (!_isEditing) {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
              ),
              if (_isEditing)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildText(),
                    Row(
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
                    ),
                  ],
                ),
              const SizedBox(height: 8),
            ],
          ),
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
          focusNode: _reviewFocusNode,
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
  }
}
