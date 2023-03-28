import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection.dart';
import 'package:shop/widgets/media/media_widget.dart';

class ParentCollectionSlider extends StatelessWidget {
  final List<Collection> root;

  const ParentCollectionSlider({Key? key, required this.root})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heightWithAppbar = MediaQuery.of(context).size.height;
    double height = heightWithAppbar - (AppBar().preferredSize.height);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
        options: CarouselOptions(
            viewportFraction: 1,
            autoPlayAnimationDuration: const Duration(seconds: 5),
            autoPlay: true,
            height: height,
            aspectRatio: width / height,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height),
        items: root
            .map((e) => _parentCollectionSlider(
                  context,
                  e,
                ))
            .toList(),
      ),
    );
  }
}

Widget _parentCollectionSlider(BuildContext context, Collection root) {
  double width = MediaQuery.of(context).size.width;
  double heightWithAppbar = MediaQuery.of(context).size.height;
  double height = heightWithAppbar - (AppBar().preferredSize.height);

  return ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
    child: MediaWidget(
      mediaId: root.media,
      width: width,
      height: height,
      onChange: () => ServiceManager<UpNavigationService>().navigateToNamed(
        Routes.products,
        queryParams: {'collection': '${root.id}'},
      ),
    ),
  );
}
     // widget.gender.img != null
      //     ? Image.memory(
      //         Uint8List.fromList(widget.gender.img!),
      //         fit: BoxFit.cover,
      //         width: 1000,
      //         height: 500,
      //       )
      //     : Container(),