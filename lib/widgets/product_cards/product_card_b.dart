import 'dart:ui';

import 'package:flutter/material.dart';

class ProductCardB extends StatelessWidget {
  const ProductCardB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.amber,
      ),
      child: _image(context),
    );
  }
}

Widget _image(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15.0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Image.asset(
        "assets/img1.jpg",
        fit: BoxFit.fill,
      ),
    ),
  );
}
