import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/price/price.dart';

class ProductInfo extends StatelessWidget {
  final Product product;
  final int? collection;

  const ProductInfo({
    Key? key,
    required this.product,
    this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getWebInfo(context, product, collection);
  }
}

Widget getWebInfo(BuildContext context, Product product, int? collection) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () {
        ServiceManager<UpNavigationService>().navigateToNamed(
          Routes.product,
          queryParams: {'productId': '${product.id}'},
        );
      },
      child: UpCard(
        style:
            UpStyle(cardHeight: 150, cardWidth: 1000, cardBodyPadding: false),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MediaWidget(
                  mediaId: product.thumbnail,
                  onChange: () => {
                    ServiceManager<UpNavigationService>().navigateToNamed(
                      Routes.product,
                      queryParams: {'productId': '${product.id}'},
                    ),
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8, top: 16, bottom: 8),
              child: SizedBox(
                // color: Colors.yellow[400],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UpText(
                      product.name,
                    ),
                    const SizedBox(height: 2),
                    PriceWidget(
                      price: product.price,
                      discountPrice: product.discounPrice,
                      discountStartDate: product.discountStartDate,
                      discountEndDate: product.discountEndDate,
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    ),
  );
}

// to check if there is discount or not
checkDisocunt(DateTime? discountStartDate, DateTime? disountEndDate) {
  bool isDiscount = false;
  // DateTime startDate = DateTime.parse(service_start_date);
  // DateTime endDate = DateTime.parse(service_end_date);

  DateTime currentDate = DateTime.now();
  if (discountStartDate != null && disountEndDate != null) {
    if (discountStartDate.isBefore(currentDate) &&
        disountEndDate.isAfter(currentDate)) {
      isDiscount = true;
    }
  }
  return isDiscount;
}
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

// Widget _image(BuildContext context, Product product) {
//   return ClipRRect(
//     borderRadius: const BorderRadius.only(
//       topLeft: Radius.circular(15.0),
//       topRight: Radius.circular(15.0),
//     ),
//     child: BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//       child: Hero(
//         tag: "tag",
//         child: InkWell(
//           onTap: () {
//           
//             
//           },
//           child: product.img != null
//               ? Image.memory(
//                   Uint8List.fromList(product.img!),
//                   fit: BoxFit.fill,
//                   height: 150,
//                   width: 200,
//                 )
//               : Container(),
//         ),
//       ),
//     ),
//   );
// }



 // return Container(
    //     margin: const EdgeInsets.all(10.0),
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           height: 150,
    //           width: 200,
    //           child: ClipRRect(
    //               borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(15.0),
    //                 topRight: Radius.circular(15.0),
    //               ),
    //               child: BackdropFilter(
    //                 filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
    //                 child: MediaWidget(
    //                   mediaId: product.media,
    //                   onChange: () =>
    //
    //                     ),
    //                   ),
    //                 ),
    //               )),
    //         ),
    //         // _image(context, product),
    //         _specification(product, context),
    //       ],
    //     ));
  