// import 'package:lazyboymcr_store/models/collection.dart';
// import 'package:lazyboymcr_store/pages/products_page/products.dart';
// import 'package:lazyboymcr_store/widgets/appbar/custom_appbar.dart';
// import 'package:lazyboymcr_store/widgets/media/media_widget.dart';
// import 'package:lazyboymcr_store/widgets/orientation_switcher.dart';
// import 'package:lazyboymcr_store/widgets/store/store_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SubCategoryPage extends StatelessWidget {
//   final int? root;

//   const SubCategoryPage({
//     Key? key,
//     this.root,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double heightWithAppbar = MediaQuery.of(context).size.height;
//     double height = heightWithAppbar - (AppBar().preferredSize.height);
//     return Scaffold(
//         appBar: CustomAppbar(),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: BlocConsumer<StoreCubit, StoreState>(
//               listener: (context, state) {},
//               builder: (context, state) {
//                 List<Collection> subCategories = state.collections!
//                     .where((c) => (c.parent == root))
//                     .toList();
//                 subCategories.map((e) => debugPrint(e.name));
//                 return Container(
//                     color: Colors.black,
//                     child: Column(
//                         children: subCategories
//                             .map(
//                               (c) => Container(
//                                 color: Colors.pink,
//                                 width: width,
//                                 height: 500,
//                                 child: OrientationSwitcher(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.center,
//                                       child: SizedBox(
//                                         width: 400,
//                                         height: 400,
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(20.0),
//                                           child: MediaWidget(
//                                             mediaId: c.media,
//                                             onChange: () =>
//                                               
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Padding(
//                                         padding: const EdgeInsets.all(20.0),
//                                         child: ElevatedButton(
//                                             
//                                             child: Text(
//                                               "Buy Now",
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .headline6!
//                                                   .copyWith(fontSize: 20),
//                                             ))),
//                                   ],
//                                 ),
//                               ),
//                             )
//                             .toList()));
//               },
//             ),
//           ),
//         ));
//   }
// }
    

//           // child:
//                             //  ColorFiltered(
//                             //   colorFilter: const ColorFilter.matrix(
//                             //     <double>[
//                             //       0.2126, 0.7152, 0.0722, 0, 0, //
//                             //       0.2126, 0.7152, 0.0722, 0, 0,
//                             //       0.2126, 0.7152, 0.0722, 0, 0,
//                             //       0, 0, 0, 1, 0,
//                             //     ],
//                             //   ),
//                             //  ),
//   // body: foundation.kIsWeb
//   //     ? WebSubCategory(
//   //         parentId: parentId,
//   //       )
//   //     : MobileSubCategory(
//   //         parentId: parentId,
//   //       ));

