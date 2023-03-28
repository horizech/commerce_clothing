import 'dart:ui';

import 'package:flutter/material.dart';

class ProductCardA extends StatelessWidget {
  const ProductCardA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 130,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.lightBlue,
      ),
      child: Stack(
        children: <Widget>[
          Container(alignment: Alignment.bottomCenter, child: _image(context)),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const FittedBox(child: Text("Name")),
                    FittedBox(
                        child: Text(
                      "Description",
                      style: Theme.of(context).textTheme.headline2,
                    )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

Widget _image(BuildContext context) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10.0),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Image.asset(
        "assets/img1.jpg",
        fit: BoxFit.fill,
        height: 100,
        width: 100,
      ),
    ),
  );
}
