// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shop/models/product_option_value.dart';
// import 'package:shop/widgets/store/store_cubit.dart';
// import 'package:shop/widgets/variations/color_variation.dart';
// import 'package:shop/widgets/variations/size_variation.dart';
// import 'package:shop/widgets/variations/variation_controller.dart';
// import 'package:shop/widgets/variations/variation_selection_mode.dart';
// import 'package:shop/widgets/variations/variation_types.dart';

// class FilterPage extends StatelessWidget {
//   final int? collection;
//   final Function? change;
//   const FilterPage({
//     Key? key,
//     this.collection,
//     this.change,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<StoreCubit, StoreState>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         List<ProductOptionValue> sizeVariations;
//         List<ProductOptionValue> colorVariations;

//         sizeVariations = state.productOptionValues!
//             .where((c) => c.collection == collection && c.productOption == 1)
//             .toList();
//         colorVariations = state.productOptionValues!
//             .where((c) => c.collection == collection && c.productOption == 2)
//             .toList();
//         return Visibility(
//           visible: (sizeVariations != [] && sizeVariations.isNotEmpty) ||
//               (colorVariations != [] && colorVariations.isNotEmpty),
//           child: Column(
//             children: [
//               VariationFilter(
//                 change: change,
//                 sizeVariations: sizeVariations,
//                 colorVariations: colorVariations,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class VariationFilter extends StatefulWidget {
//   // int? category;
//   List<ProductOptionValue>? sizeVariations;
//   List<ProductOptionValue>? colorVariations;
//   Function? change;
//   VariationFilter(
//       {Key? key,
//       // required this.category,
//       this.sizeVariations,
//       this.colorVariations,
//       //  required this.variations,
//       this.change})
//       : super(key: key);

//   @override
//   State<VariationFilter> createState() => _VariationFilterState();
// }

// class _VariationFilterState extends State<VariationFilter> {
//   Map<int, List<int>> selectedVariationsValues = {};
//   Map<int, VariationController> variationControllers = {};

//   onVariationChange(int? key, List<int> values) {
//     debugPrint("you clicked on $values for $key");
//     setState(() {
//       selectedVariationsValues[key!] = values;
//     });
//   }

//   onChange() {
//     widget.change!(selectedVariationsValues);
//   }

//   onReset() {
//     variationControllers.values
//         .toList()
//         .forEach((controller) => controller.reset!());
//     setState(() {
//       selectedVariationsValues.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (variationControllers.isEmpty) {
//       for (var element in VariationTypes.values) {
//         variationControllers[element.index] = VariationController();
//       }
//     }

//     if (selectedVariationsValues.isEmpty) {
//       for (var element in VariationTypes.values) {
//         selectedVariationsValues[element.index] = [];
//       }
//     }

//     return Wrap(
//       children: [
//         Column(
//           children: [
//             Wrap(children: [
//               widget.sizeVariations != null && widget.sizeVariations!.isNotEmpty
//                   ? const Text("Sizes : ")
//                   : const Text(""),
//               SizeVariationWidget(
//                 sizeVariations: widget.sizeVariations,
//                 onChange: (s) =>
//                     onVariationChange(VariationTypes.size.index, s),
//                 mode: VariationSelectionMode.filter,
//                 controller: variationControllers[VariationTypes.size.index],
//               ),
//             ]),
//             Wrap(children: [
//               widget.colorVariations != null &&
//                       widget.colorVariations!.isNotEmpty
//                   ? const Text("Colors : ")
//                   : const Text(""),
//               ColorVariationWidget(
//                 colorVariations: widget.colorVariations,
//                 onChange: (c) =>
//                     onVariationChange(VariationTypes.color.index, c),
//                 mode: VariationSelectionMode.filter,
//                 controller: variationControllers[VariationTypes.color.index],
//               ),
//             ]),
//             GestureDetector(
//               onTap: onReset,
//               child: Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 runAlignment: WrapAlignment.center,
//                 children: [
//                   const Padding(padding: EdgeInsets.all(10.0)),
//                   const Icon(
//                     Icons.delete_outline,
//                     size: 30,
//                   ),
//                   Text(
//                     "Clear Filters",
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline2!
//                         .copyWith(fontSize: 16),
//                   ),
//                 ],
//               ),
//             ),
//             // ElevatedButton(onPressed: onReset, child: const Text("remove filter")),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                   onPressed: onChange, child: const Text("Apply Filter")),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }


// // class VariationFilter extends StatefulWidget {
// //   int? category;
// //   // List<Variation> variations;
// //   Function? change;
// //   VariationFilter(
// //       {Key? key,
// //       required this.category,
// //       //  required this.variations,
// //       this.change})
// //       : super(key: key);

// //   @override
// //   State<VariationFilter> createState() => _VariationFilterState();
// // }

// // class _VariationFilterState extends State<VariationFilter> {
// //   Map<int, List<String>> selectedVariationsValues = {};
// //   Map<int, VariationController> variationControllers = {};

// //   onVariationChange(int key, List<String> values) {
// //     debugPrint("you clicked on $values for $key");
// //     setState(() {
// //       selectedVariationsValues[key] = values;
// //     });
// //   }

// //   onChange() {
// //     widget.change!(selectedVariationsValues);
// //   }

// //   onReset() {
// //     variationControllers.values
// //         .toList()
// //         .forEach((controller) => controller.reset!());
// //     setState(() {
// //       selectedVariationsValues.clear();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // if (variationControllers.isEmpty) {
// //     //   for (var x in widget.category.variations) {
// //     //     variationControllers[x] = VariationController();
// //     //   }
// //     // }
// //     // if (selectedVariationsValues.isEmpty) {
// //     //   for (var variationId in widget.category.variations) {
// //     //     selectedVariationsValues[variationId] = [];
// //     //   }
// //     // }
// //     return Wrap(
// //       children: [
// //         Column(
// //           children: [
// //             //    widget.category.variations
// //             //       .map(
// //             //         (variationId) => VariationSelector(
// //             //           variation: widget.variations
// //             //               .where((element) => element.id == variationId)
// //             //               .first,
// //             //           onChange: (s) => onVariationChange(variationId, s),
// //             //           maxSelectCount: -1,
// //             //           controller: variationControllers[variationId],
// //             //         ),
// //             //       )
// //             //       .toList(),
// //             // ),
// //                  SizeVariationWidget(
// //           // variation: variation,
// //           onChange: onChange,
// //           // selectedValues: selectedVariationsValues.keys.contains(variation.id)
// //           //     ? selectedVariationsValues[variation.id]
// //           //     : null,
// //           maxSelectCount: -1,
// //           // controller: controller,
// //         ),
// //             GestureDetector(
// //               onTap: onReset,
// //               child: Wrap(
// //                 crossAxisAlignment: WrapCrossAlignment.center,
// //                 runAlignment: WrapAlignment.center,
// //                 children: [
// //                   const Padding(padding: EdgeInsets.all(10.0)),
// //                   Container(
// //                     child: const Icon(
// //                       Icons.delete_outline,
// //                       size: 30,
// //                     ),
// //                   ),
// //                   Container(
// //                     child: Text(
// //                       "Clear Filters",
// //                       style: Theme.of(context)
// //                           .textTheme
// //                           .headline2!
// //                           .copyWith(fontSize: 16),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // ElevatedButton(onPressed: onReset, child: const Text("remove filter")),
// //             Padding(
// //               padding: const EdgeInsets.all(8.0),
// //               child: ElevatedButton(
// //                   onPressed: onChange, child: const Text("Apply Filter")),
// //             ),
// //           ],
//         // )
// //       ],
// //     );
// //   }
// // }
