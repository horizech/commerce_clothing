// import 'dart:ui';

// import 'package:lazyboymcr_store/models/product.dart';
// import 'package:lazyboymcr_store/pages/product-detail/product_detail.dart';
// import 'package:lazyboymcr_store/widgets/media/media_widget.dart';
// import 'package:flutter/material.dart';

// class ProductCard extends StatelessWidget {
//   final Product product;

//   const ProductCard({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         margin: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 150,
//               width: 200,
//               child: ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(15.0),
//                     topRight: Radius.circular(15.0),
//                   ),
//                   child: BackdropFilter(
//                     filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//                     child: MediaWidget(
//                       mediaId: product.media,
//                       onChange: () => 
//                         ),
//                       ),
//                     ),
//                   )),
//             ),
//             // _image(context, product),
//             _specification(product, context),
//           ],
//         ));
//   }
// }

// Widget _specification(Product product, BuildContext context) {
//   return Container(
//       height: 150,
//       width: 200,
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//           border: Border.all(
//               width: 0, style: BorderStyle.solid, color: Colors.black),
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(15.0),
//             bottomRight: Radius.circular(15.0),
//           ),
//           color: Colors.white),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Text(
//             product.name,
//             style: Theme.of(context).textTheme.headline1,
//           ),
//           Text(
//             product.description,
//             style: Theme.of(context).textTheme.headline2,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               Text(
//                 'Pkr ${product.price}',
//               ),
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                   ),
//                   onPressed: () {
//                   
//                   },
//                   child: const Text('Shop Now')),
//             ],
//           ),
//         ],
//       ));
// }

// // Widget _image(BuildContext context, Product product) {
// //   return ClipRRect(
// //     borderRadius: const BorderRadius.only(
// //       topLeft: Radius.circular(15.0),
// //       topRight: Radius.circular(15.0),
// //     ),
// //     child: BackdropFilter(
// //       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
// //       child: Hero(
// //         tag: "tag",
// //         child: InkWell(
// //           onTap: () {
// //           
// //             );
// //           },
// //           child: product.img != null
// //               ? Image.memory(
// //                   Uint8List.fromList(product.img!),
// //                   fit: BoxFit.fill,
// //                   height: 150,
// //                   width: 200,
// //                 )
// //               : Container(),
// //         ),
// //       ),
// //     ),
// //   );
// // }
