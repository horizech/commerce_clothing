import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/widgets/products/product_info.dart';

class ProductsList extends StatelessWidget {
  final List<Product> products;
  final int limit;
  final int? collection;

  const ProductsList({
    Key? key,
    this.limit = -1,
    required this.products,
    this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((products).isEmpty) {
      return const Center(
        child: SizedBox(
            width: 200,
            height: 200,
            child: Center(child: Text("No Product Available"))),
      );
    } else {
      return Container(
        child: _allProductsList(context, products, collection),
      );
    }
  }
}

Widget _allProductsList(
    BuildContext context, List<Product> products, int? collection) {
  return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ProductInfo(product: products[index], collection: collection);
        },
        itemCount: products.length,
      ));
}



// Widget _allProductsList(BuildContext context, List<Product> products) {
//   return Padding(
//     padding: const EdgeInsets.all(30.0),
//     child: Center(
//       child: Wrap(
//         runAlignment: WrapAlignment.center,
//         crossAxisAlignment: WrapCrossAlignment.center,
//         spacing: 10.0,
//         children: List.generate(
//           products.length,
//           (index) {
//             return ProductCard(
//               product: products[index],
//             );
//           },
//         ),
//       ),
//     ),
//   );
// }


