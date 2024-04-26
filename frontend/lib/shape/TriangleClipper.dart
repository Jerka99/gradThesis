import 'package:flutter/cupertino.dart';

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // print(size.height);
    // print(size.width);
    path.moveTo(size.width / 2, size.height - 20); // Move to the
    // bottom-center point
    path.lineTo(size.width, 25.0); // Line to the top-right corner
    path.quadraticBezierTo(
        size.width/ 2, -size.height/ 1.5, 0.0, 25.0);
    // path.lineTo(0.0, 20.0); // Line to the top-left corner
    path.close(); // Close the path to form a triangle
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
