// import 'dart:ui';

// import 'package:lazyboymcr_store/models/collection.dart';
// import 'package:lazyboymcr_store/pages/Category/sub_category_page.dart';
// import 'package:lazyboymcr_store/widgets/media/media_widget.dart';
// import 'package:flutter/material.dart';

// class ParentCategories extends StatelessWidget {
//   final List<Collection> categories;

//   const ParentCategories({Key? key, required this.categories})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 100,
//         child: ListView.builder(
//             itemCount: categories.length,
//             scrollDirection: Axis.horizontal,
//             itemBuilder: (context, index) {
//               return _categoryCard(categories[index], context);
//             }),
//       ),
//     );
//   }
// }

// Widget _categoryCard(Collection category, BuildContext context) {
//   return InkWell(
//     onTap: () {},
//     child: Padding(
//       padding: const EdgeInsets.all(5.0),
//       child: Container(
//         // color: Colors.amberAccent,
//         child: Stack(
//           children: <Widget>[
//             _image(context, category),
//             // Center(child: Text(category.name)),
//           ],
//         ),
//       ),
//     ),
//   );
// }

// Widget _image(BuildContext context, Collection category) {
//   return ClipRRect(
//     borderRadius: const BorderRadius.all(
//       Radius.circular(100.0),
//     ),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//       child: MediaWidget(mediaId: category.media, onChange: () {}
//          
//           ),
//     ),
//   );
// }
