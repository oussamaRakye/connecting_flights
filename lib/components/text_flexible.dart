import 'package:flutter/material.dart';

class TextFlexible extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const TextFlexible(this.text, {Key? key, this.style}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: style,
      ),
    );
  }
}
