// import 'package:lazyboymcr_store/models/category.dart';
// import 'package:lazyboymcr_store/models/product.dart';
// import 'package:lazyboymcr_store/pages/products_page/products.dart';
// import 'package:lazyboymcr_store/widgets/dummy/dummy_subcategory_page.dart';
// import 'package:lazyboymcr_store/widgets/products/products_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lazyboymcr_store/pages/authentication/authentication_cubit.dart';

// class ProductCategoryPreview extends StatelessWidget {
//   final List<Category> categories;

//   const ProductCategoryPreview({
//     Key? key,
//     required this.categories,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         height: 200,
//         child: ListView.builder(
//             physics: const ClampingScrollPhysics(),
//             itemCount: categories.length,
//             itemBuilder: (context, index) {
//               return _categoryGrid(
//                 context,
//                 categories[index],
//               );
//             }),
//       ),
//     );
//   }
// }

// Widget _categoryGrid(
//   BuildContext context,
//   Category category,
// ) {
//   return BlocConsumer<ApiraiserAuthenticationCubit, ApiraiserAuthenticationState>(
//     listener: (context, state) {
//       if (state.isSuccessful) {
//       } else if (state.isError) {}
//     },
//     builder: (context, state) => FutureBuilder<List<Product>>(
//         future: ProductService.getProducts(category.id, -1),
//         builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
//           if (snapshot.connectionState != ConnectionState.done) {
//             return const DummySubcategoryPage();
//           }
//           return Container(
//             // color: Colors.lightGreen,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(category.name),
//                       ),
//                       GestureDetector(
//                        
//                         child: Row(
//                           children: const [
//                             Text(
//                               "Show more",
//                             ),
//                             Icon(Icons.arrow_forward),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   // Products(
//                   //   products: snapshot.data!,
//                   //   limit: 2,
//                   // ),
//                 ],
//               ),
//             ),
//           );
//         }),
//   );
// }
