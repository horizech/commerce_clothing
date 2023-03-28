// import 'dart:ui';

// import 'package:lazyboymcr_store/models/product.dart';
// import 'package:lazyboymcr_store/pages/product-detail/product_detail.dart';
// import 'package:lazyboymcr_store/widgets/media/media_widget.dart';
// import 'package:flutter/material.dart';

// class ProductCardLimited extends StatelessWidget {
//   final Product product;

//   const ProductCardLimited({Key? key, required this.product}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {},
//       child: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: Stack(
//           children: <Widget>[
//             ClipRRect(
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(10.0),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//                 child: MediaWidget(
//                   mediaId: product.media,
//                  
//                   ),
//                 ),
//               ),
//             ),
//             // _image(context, product),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Widget _image(BuildContext context, Product product) {
// //   return ClipRRect(
// //     borderRadius: const BorderRadius.all(
// //       Radius.circular(10.0),
// //     ),
// //     child: BackdropFilter(
// //       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// //       child: InkWell(
// //         
// //             ),
// //           );
// //         },
// //         child: product.img != null
// //             ? Image.memory(
// //                 Uint8List.fromList(product.img!),
// //                 fit: BoxFit.fill,
// //                 height: 150,
// //                 width: 200,
// //               )
// //             : Container(),
// //       ),
// //     ),
// //   );
// // }

// // Widget _categoryWeb(BuildContext context) {
// //   return Padding(
// //     padding: const EdgeInsets.all(8.0),
// //     child: Center(
// //       child: Wrap(
// //         runAlignment: WrapAlignment.center,
// //         crossAxisAlignment: WrapCrossAlignment.center,
// //         spacing: 20.0,
// //         children: List.generate(
// //           6,
// //           (index) {
// //             return InkWell(
// //               onTap: () {},
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Container(
// //                   width: 250,
// //                   height: 200,
// //                   padding: const EdgeInsets.all(10),
// //                   decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(10.0),
// //                       color: Colors.black),
// //                   child: Center(
// //                     child: Text(
// //                       "category $index",
// //                       style: const TextStyle(color: Colors.white),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             );
// //           },
// //         ),
// //       ),
// //     ),
// //   );
// // }
