import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, required this.maxLines});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text(
        widget.text,
        // don't write a review longer than 100 lines
        maxLines: isExpanded ? 100 : widget.maxLines,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 15,
          letterSpacing: .2,
          height: 1.3,
        ),
      ),
    );
  }
}
