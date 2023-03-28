import 'dart:ui';

import 'package:flutter/material.dart';

class ProductCardD extends StatelessWidget {
  const ProductCardD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 100,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.amber,
      ),
      child: _image(context),
    );
  }
}

Widget _image(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5.0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Image.asset(
        "assets/img1.jpg",
        fit: BoxFit.fill,
      ),
    ),
  );
}
