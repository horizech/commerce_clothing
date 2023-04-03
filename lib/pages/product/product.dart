import 'dart:typed_data';

import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/media.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_detail.dart';
import 'package:shop/models/product_variation.dart';
import 'package:shop/models/stock.dart';
import 'package:shop/widgets/appbar/custom_appbar.dart';
import 'package:shop/widgets/cart/cart_cubit.dart';
import 'package:shop/widgets/counter.dart';
import 'package:shop/widgets/drawer/drawer.dart';
import 'package:shop/widgets/error/error.dart';
import 'package:shop/widgets/header/header.dart';
import 'package:shop/widgets/media/media_service.dart';
import 'package:shop/widgets/orientation_switcher.dart';
import 'package:shop/widgets/price/price.dart';
import 'package:shop/widgets/products/product_detail_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/variations/color_variation.dart';
import 'package:shop/widgets/variations/size_variation.dart';
import 'package:shop/widgets/variations/variation_controller.dart';
import 'package:shop/widgets/variations/variation_types.dart';

class ProductPage extends StatelessWidget {
  final Map<String, String>? queryParams;
  const ProductPage({Key? key, this.queryParams}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? productId;
    if (queryParams != null &&
        queryParams!.isNotEmpty &&
        queryParams!['productId'] != null &&
        queryParams!['productId']!.isNotEmpty) {
      productId = int.parse(queryParams!['productId']!);
    }

    List<ProductVariation>? productVariations = [];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomAppbar(
        scaffoldKey: scaffoldKey,
      ),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: productId != null
          ? FutureBuilder<ProductDetail?>(
              future: ProductDetailService.getProductDetail(productId),
              builder: (BuildContext context,
                  AsyncSnapshot<ProductDetail?> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const UpCircularProgress(
                    width: 30,
                    height: 30,
                  );
                }
                if (snapshot.connectionState != ConnectionState.done) {
                  return const UpCircularProgress(
                    width: 30,
                    height: 30,
                  );
                }

                return snapshot.hasData && snapshot.data!.product != null
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const HeaderWidget(),
                            ProductDetailedInfo(
                              product: snapshot.data!.product!,
                              productVariations:
                                  snapshot.data!.productVariations != null &&
                                          snapshot.data!.productVariations!
                                              .isNotEmpty
                                      ? snapshot.data!.productVariations
                                      : null,
                              stock: snapshot.data!.stock != null &&
                                      snapshot.data!.stock!.isNotEmpty
                                  ? snapshot.data!.stock
                                  : null,
                            ),
                          ],
                        ),
                      )
                    : const NotFoundErrorWidget();
              },
            )
          : const NotFoundErrorWidget(),
    );
  }
}

class ProductDetailedInfo extends StatefulWidget {
  final Product product;
  final int? collection;
  final List<ProductVariation>? productVariations;
  final List<Stock>? stock;

  const ProductDetailedInfo(
      {Key? key,
      required this.product,
      this.collection,
      this.productVariations,
      this.stock})
      : super(key: key);

  @override
  State<ProductDetailedInfo> createState() => _ProductDetailedInfoState();
}

class _ProductDetailedInfoState extends State<ProductDetailedInfo> {
  Map<int, int> selectedVariationsValues = {0: 0, 1: 0};
  Map<int, VariationController> variationControllers = {};
  int? gallery = 0;
  bool? mainMediaUpdate = false;
  int quantity = 0;
  List<AttributeValue> sizeVariation = [];
  List<AttributeValue> colorVariation = [];
  List<int> disabledSizes = [];
  List<int> disabledColors = [];
  int maxItems = -1;
  List<int> mediaList = [];
  int sizeAttributeId = 0;
  int colorAttributeId = 0;
  int? selectedVariationId;
  int defaultValue = 1;

  static int convertToInt(dynamic a) {
    return int.parse(a.toString());
  }

  onVariationChange(int key, List<int> values) {
    if (key == VariationTypes.color.index) {
      selectedVariationsValues[key] = values[0];

      List<int> allowedSizes = widget.productVariations!
          .where((element) =>
              values.contains(element.options["$colorAttributeId"]) &&
              element.options["$sizeAttributeId"] != null)
          .map(
            (e) => e.options["$sizeAttributeId"]!,
          )
          .map((e) => convertToInt(e))
          .toSet()
          .toList();

      if (sizeVariation.isNotEmpty) {
        setState(() {
          disabledSizes = sizeVariation
              .where((element) => !allowedSizes.contains(element.id))
              .map((e) => e.id!)
              .toList();
          if (disabledSizes
              .contains(selectedVariationsValues[VariationTypes.size.index])) {
            // reset sizes

            variationControllers[VariationTypes.size.index]!.reset!();
          }
        });
      }
    }

    if (key == VariationTypes.size.index) {
      selectedVariationsValues[key] = values[0];

      List<int> allowedColors = widget.productVariations!
          .where((element) =>
              values.contains(element.options["$sizeAttributeId"]) &&
              element.options["$colorAttributeId"] != null)
          .map(
            (e) => e.options["$colorAttributeId"]!,
          )
          .map((e) => convertToInt(e))
          .toSet()
          .toList();

      if (colorVariation.isNotEmpty) {
        setState(() {
          disabledColors = colorVariation
              .where((element) => !allowedColors.contains(element.id))
              .map((e) => e.id!)
              .toList();
          if (disabledColors
              .contains(selectedVariationsValues[VariationTypes.color.index])) {
            // reset color
            variationControllers[VariationTypes.color.index]!.reset!();
          }
        });
      }
    }

    if (selectedVariationsValues.isNotEmpty &&
        selectedVariationsValues[VariationTypes.color.index] != 0 &&
        selectedVariationsValues[VariationTypes.size.index] != 0) {
      maxItems = 0;
      if (widget.productVariations!.any((v) =>
          (v.options["$colorAttributeId"] ==
                  selectedVariationsValues[VariationTypes.color.index] &&
              v.options["$sizeAttributeId"] ==
                  selectedVariationsValues[VariationTypes.size.index]))) {
        selectedVariationId = widget.productVariations!
            .firstWhere((v) => (v.options["$colorAttributeId"] ==
                    selectedVariationsValues[VariationTypes.color.index] &&
                v.options["$sizeAttributeId"] ==
                    selectedVariationsValues[VariationTypes.size.index]))
            .id!;
        if (widget.productVariations != null &&
            widget.productVariations!.isNotEmpty) {
          gallery = widget.productVariations!
              .firstWhere(
                (v) => (v.options["$colorAttributeId"] ==
                        selectedVariationsValues[VariationTypes.color.index] &&
                    v.options["$sizeAttributeId"] ==
                        selectedVariationsValues[VariationTypes.size.index]),
              )
              .gallery;
        }

        mainMediaUpdate = true;
        if (widget.stock != null && widget.stock!.isNotEmpty) {
          if (widget.stock!
              .any((s) => s.productVariation == selectedVariationId)) {
            maxItems = widget.stock!
                .firstWhere((s) => s.productVariation == selectedVariationId)
                .quantity;
            defaultValue = 1;
            quantity = 1;
          }
        }
        mainMediaUpdate = true;

        0;
        mediaList = [];
      } else {
        maxItems = -1;
        mainMediaUpdate = false;
        gallery = widget.product.gallery;
      }
    }
  }

  onQuantityChange(int count) {
    quantity = count;
  }

  @override
  Widget build(BuildContext context) {
    int totalStock = 0;
    List<dynamic> sizes = [];
    List<dynamic> colors = [];
    try {
      return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.attributes != null && state.attributes!.isNotEmpty) {
            if (state.attributes!
                .any((element) => element.name.toLowerCase() == "size")) {
              sizeAttributeId = state.attributes!
                  .firstWhere((element) => element.name == "Size")
                  .id!;
            }
            if (state.attributes!
                .any((element) => element.name.toLowerCase() == "color")) {
              colorAttributeId = state.attributes!
                  .firstWhere((element) => element.name == "Color")
                  .id!;
            }
          }

          if (widget.productVariations != null &&
              widget.productVariations!.isNotEmpty &&
              maxItems == -1 &&
              sizes.isEmpty &&
              colors.isEmpty) {
            sizes = widget.productVariations!
                .map((e) => e.options["$sizeAttributeId"])
                .toSet()
                .toList();

            colors = widget.productVariations!
                .map((e) => e.options["$colorAttributeId"])
                .where((element) => element > 0)
                .toSet()
                .toList();
          }
          if (state.attributeValues != null &&
              state.attributeValues!.isNotEmpty) {
            List<AttributeValue> allSizes = state.attributeValues!
                .where((e) => e.attribute == sizeAttributeId)
                .toList();

            List<AttributeValue> allColors = state.attributeValues!
                .where((e) => e.attribute == colorAttributeId)
                .toList();

            if (colorVariation.isEmpty && sizeVariation.isEmpty) {
              try {
                //variation sizes list
                for (int i = 0; i < sizes.length; i++) {
                  sizeVariation.add(allSizes
                      .where((element) => element.id == sizes[i])
                      .first);
                }
                //variation color list

                for (int i = 0; i < colors.length; i++) {
                  colorVariation.add(allColors
                      .where((element) => element.id == colors[i])
                      .first);
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          }

          if (gallery == 0) {
            gallery = widget.product.gallery;
          }

          if (variationControllers.isEmpty) {
            for (var element in VariationTypes.values) {
              variationControllers[element.index] = VariationController();
            }
          }

          if (mediaList.isEmpty) {
            mediaList =
                state.gallery!.firstWhere((m) => m.id == gallery).mediaList;
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  OrientationSwitcher(
                    children: [
                      GetMedia(mediaList: mediaList),
                      // MediaGrid(
                      //     mediaList: mediaList,
                      //     mainMediaUpdate: mainMediaUpdate),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: UpText(
                              widget.product.name,
                              style: UpStyle(textSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const DottedLine(),
                          const SizedBox(
                            height: 10,
                          ),
                          PriceWidget(
                            price: widget.product.price,
                            discountPrice: widget.product.discounPrice,
                            discountStartDate: widget.product.discountStartDate,
                            discountEndDate: widget.product.discountEndDate,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: widget.productVariations != null &&
                                widget.productVariations!.isNotEmpty,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Size",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(fontSize: 16),
                                  ),
                                  SizeVariationWidget(
                                    sizeVariations: sizeVariation,
                                    disabledValues: disabledSizes,
                                    onChange: (s) => onVariationChange(
                                        VariationTypes.size.index, s),
                                    controller: variationControllers[
                                        VariationTypes.size.index],
                                    // selectedValues: selectedVariationsValues.,
                                  ),
                                  Text(
                                    "Color",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(fontSize: 16),
                                  ),
                                  ColorVariationWidget(
                                    colorVariations: colorVariation,
                                    disabledValues: disabledColors,
                                    onChange: (c) => onVariationChange(
                                        VariationTypes.color.index, c),
                                    controller: variationControllers[
                                        VariationTypes.color.index],
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Quantity:  "),
                              maxItems == -1
                                  ? const Text(
                                      "Please select all variations first")
                                  : maxItems > 0
                                      ? Row(
                                          children: [
                                            Counter(
                                              defaultValue: defaultValue,
                                              onChange: onQuantityChange,
                                              maxItems: maxItems,
                                            ),
                                            // Text("only $maxItems Items left"),
                                          ],
                                        )
                                      : Text("OUT OF STOCK",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .copyWith(color: Colors.red))
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: maxItems > 0
                                ? UpButton(
                                    onPressed: () {
                                      if (widget.product.isVariedProduct) {
                                        if (quantity > 0 &&
                                            quantity <= maxItems &&
                                            selectedVariationId != null) {
                                          SnackBar snackBar = SnackBar(
                                            content: Text(
                                                '$quantity products added to cart'),
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          CartCubit cubit =
                                              context.read<CartCubit>();
                                          CartItem item = CartItem(
                                              product: widget.product,
                                              selectedVariation: widget
                                                              .productVariations !=
                                                          null &&
                                                      widget.productVariations!
                                                          .isNotEmpty
                                                  ? widget.productVariations!
                                                      .where((element) =>
                                                          element.id ==
                                                          selectedVariationId)
                                                      .first
                                                  : null,
                                              quantity: quantity);
                                          cubit.addToCart(item);
                                        } else {
                                          SnackBar snackBar = const SnackBar(
                                            content: Text(
                                                'Select quantity and variations'),
                                            duration: Duration(seconds: 3),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      } else {
                                        if (quantity > 0 &&
                                            quantity <= maxItems) {
                                          SnackBar snackBar = SnackBar(
                                            content: Text(
                                                '$quantity products added to cart'),
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                          CartCubit cubit =
                                              context.read<CartCubit>();
                                          CartItem item = CartItem(
                                              product: widget.product,
                                              selectedVariation: null,
                                              quantity: quantity);
                                          cubit.addToCart(item);
                                        } else {
                                          SnackBar snackBar = const SnackBar(
                                            content: Text('Select quantity '),
                                            duration: Duration(seconds: 3),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    text: "Add to cart")
                                : UpButton(
                                    onPressed: () {},
                                    style: UpStyle(isDisabled: true),
                                    text: "Add to cart"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: maxItems > 0
                                ? UpButton(
                                    onPressed: () =>
                                        ServiceManager<UpNavigationService>()
                                            .navigateToNamed(
                                      Routes.payment,
                                    ),
                                    text: "Buy Now",
                                  )
                                : UpButton(
                                    style: UpStyle(isDisabled: true),
                                    onPressed: () {},
                                    text: "Buy Now",
                                  ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _productDetais(widget.product, context),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

Widget _productDetais(Product product, BuildContext context) {
  return ExpansionTile(
    title: const Text("Product Details"),
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text("Description: ${product.description}"),
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text("Fabric: cotton"),
        ),
      ),
    ],
  );
}

Widget ourServices(BuildContext context) {
  return Wrap(spacing: 10.0, children: [
    Container(
      color: Colors.white30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fire_truck, size: 40),
              Text("Shipping Charges",
                  style: Theme.of(context).textTheme.headline1),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 0, bottom: 10),
            child: Text(
              "Flat Rs. 200 on all orders ",
              style: Theme.of(context).textTheme.headline2,
            ),
          )
        ],
      ),
    ),
    Container(
      color: Colors.white30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hourglass_bottom, size: 40),
              Text("Support 24/7", style: Theme.of(context).textTheme.headline1)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 0, bottom: 10),
            child: Text(
              "Contact us 24/7 hours",
              style: Theme.of(context).textTheme.headline2,
            ),
          )
        ],
      ),
    ),
    Container(
      color: Colors.white30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.pin_drop, size: 40),
              Text("Track Your Order",
                  style: Theme.of(context).textTheme.headline1),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 0, bottom: 10),
            child: Text(
              "track your order for quick updates",
              style: Theme.of(context).textTheme.headline2,
            ),
          )
        ],
      ),
    )
  ]);
}

class GetMedia extends StatelessWidget {
  final List<int> mediaList;
  const GetMedia({Key? key, required this.mediaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //      Mediacubit cubit = context.read<Mediacubit>();
    // cubit.getMedia(mediaList);
    // return BlocConsumer<Mediacubit, MediaState>(
    //     listener: (context, state) {},
    //     builder: (context, state) {
    //       // if (state.isLoading) {
    //       //   return const SizedBox(
    //       //       width: 50, height: 20, child: CircularProgressIndicator());
    //       // }
    //       if (state.isSuccessful) {
    //         return ProductImages(mediaList: state.mediaList);
    //       } else {
    //         return const SizedBox(
    //           height: 10,
    //           width: 50,
    //           child: Center(
    //             child: CircularProgressIndicator(),
    //           ),
    //         );
    //       }
    //     });
    return FutureBuilder<List<Media>>(
        future: MediaService.getMediaByList(mediaList),
        builder: (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container(
              height: 500,
              color: Colors.grey[200],
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator())
                    ]),
              ),
            );
          }
          return snapshot.hasData
              ? ProductImages(
                  mediaList: snapshot.data!,
                )
              : const CircularProgressIndicator();
        });
  }
}

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.mediaList,
  }) : super(key: key);

  final List<Media> mediaList;

  @override
  ProductImagesState createState() => ProductImagesState();
}

class ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          SizedBox(
            width: 400,
            child: AspectRatio(
              aspectRatio: 1,
              child: Hero(
                tag: widget.mediaList[selectedImage].id.toString(),
                child: widget.mediaList[selectedImage].img != null &&
                        widget.mediaList[selectedImage].img!.isNotEmpty
                    ? Image.memory(
                        Uint8List.fromList(
                            widget.mediaList[selectedImage].img!),
                        gaplessPlayback: true,
                      )
                    : FadeInImage.assetNetwork(
                        placeholder: "assets/loading.gif",
                        image: widget.mediaList[selectedImage].url!,
                      ),
              ),
            ),
          ),
          // SizedBox(height: getProportionateScreenWidth(20)),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(widget.mediaList.length,
                    (index) => buildSmallProductPreview(index)),
              ],
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    const kPrimaryColor = Color(0xFFFF8F00);
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: Container(
        // duration: const Duration(seconds: 2),
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: widget.mediaList[selectedImage].img != null &&
                widget.mediaList[selectedImage].img!.isNotEmpty
            ? Image.memory(
                Uint8List.fromList(widget.mediaList[index].img!),
                gaplessPlayback: true,
              )
            : FadeInImage.assetNetwork(
                placeholder: "assets/loading.gif",
                image: widget.mediaList[index].url!,
              ),
      ),
    );
  }
}

// style: ElevatedButton.styleFrom(
//   primary: Colors.white,
//   onPrimary: Colors.black,
//   padding: const EdgeInsets.symmetric(
//       horizontal: 110, vertical: 15),
//   textStyle: const TextStyle(
//       fontSize: 20, fontWeight: FontWeight.w500),
//   shape: const RoundedRectangleBorder(
//     side: BorderSide(color: Colors.black),
//   ),
// ),

  // Row(
  //   children: [
  //     Text(
  //       "Availability: ",
  //       style: Theme.of(context).textTheme.headline4,
  //     ),
  //     totalStock > 0
  //         ? Row(
  //             children: [
  //               Text(
  //                 "In Stock",
  //                 style: Theme.of(context).textTheme.headline5,
  //               ),
  //               Text("(Hurry up only $maxItems items left)",
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .headline5!
  //                       .copyWith(color: Colors.red))
  //             ],
  //           )
  //         : Text("oUT OF STOCK",
  //             style: Theme.of(context)
  //                 .textTheme
  //                 .headline5!
  //                 .copyWith(color: Colors.red))
  //   ],
  // ),

// Visibility(
  //   visible: product.variations.isNotEmpty,
  //   child: Column(
  //     children: product.variations.keys.map(
  //       (variationId) {
  //         Variation variation = variations
  //             .where((element) => element.id == variationId)
  //             .first;
  //         return VariationSelector(
  //             variation: Variation(
  //                 variation.id,
  //                 variation.createdOn,
  //                 variation.createdBy,
  //                 variation.lastUpdatedOn,
  //                 variation.lastUpdatedBy,
  //                 variation.name,
  //                 product.variations[variationId].join(","),
  //                 variation.type),
  //             maxSelectCount: 1,
  //             onChange: (s) => onVariationChange(variationId, s));
  //       },
  //     ).toList(),
  //   ),
  // ),

  // if (selectedVariationsValues.isNotEmpty &&
  //     selectedVariationsValues[0] != 0 &&
  //     selectedVariationsValues[1] != 0) {
  //   maxItems = 0;
  //   int? selectedProductVariationId = widget.product.variations
  //       .where((v) => (v.color ==
  //               selectedVariationsValues[VariationTypes.color.index] &&
  //           v.color == selectedVariationsValues[VariationTypes.size.index]))
  //       .map((e) => e.id)
  //       .first;
  //   maxItems = widget.stock
  //       .where((s) => s.productVariation == selectedProductVariationId)
  //       .map((e) => e.quantity)
  //       .first;

  //   setState(() {
  //     maxItems = maxItems;
  //   });
