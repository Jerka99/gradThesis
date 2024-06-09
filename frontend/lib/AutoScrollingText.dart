import 'package:flutter/cupertino.dart';
import 'package:text_scroll/text_scroll.dart';

class AutoScrollingText extends StatefulWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Offset offset;

  AutoScrollingText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.offset,
  });

  @override
  State<AutoScrollingText> createState() => _AutoScrollingTextState();
}

class _AutoScrollingTextState extends State<AutoScrollingText> {
  @override
  Widget build(BuildContext context) {
    return TextScroll(
      widget.text,
      intervalSpaces: 5,
      mode: TextScrollMode.endless,
      velocity: Velocity(pixelsPerSecond: widget.offset),
      pauseBetween: const Duration(milliseconds: 2000),
      style:
          TextStyle(fontSize: widget.fontSize, fontWeight: widget.fontWeight),
    );
  }
}
