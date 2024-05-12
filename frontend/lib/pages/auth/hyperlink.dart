import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HyperLink extends StatelessWidget {

  String text;
  String linkText;
  Function() link;

  HyperLink({
    required this.text,
    required this.linkText,
    required this.link,
    super.key});


  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                text: text,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: linkText,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    link();
                  },
              ),
            ]
        ));
  }
}
