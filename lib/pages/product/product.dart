import 'dart:typed_data';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_circualar_progress.dart';
import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_swatch.dart';
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
import 'package:shop/widgets/variations/variation_selection_mode.dart';

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
    return UpScaffold(
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
  Map<int, dynamic> selectedVariationsValues = {};
  Map<int, VariationController> variationControllers = {};
  int? gallery = 0;
  bool? mainMediaUpdate = false;
  int quantity = 0;
  int maxItems = -1;
  List<int> mediaList = [];
  int? selectedVariationId;
  int defaultValue = 1;
  List<Attribute> attributes = [];
  List<AttributeValue> attributeValues = [];
  List<AttributeSwatch> attributeSwatches = [];
  Map<Attribute, List<AttributeValue>> variations = {};
  Map<int, List<int>> disabledVariations = {};
  Map<int, List<int>> selectedVariations = {};

  clearSelectedVariation(int keyIndex) {
    Map<int, dynamic> map = {};
    selectedVariationsValues.forEach((key, value) {
      if (keyIndex != key) {
        map[key] = value;
      }
    });
    return map;
  }

  onVariationChange(int keyValue, List<int> values) {
    selectedVariationsValues[keyValue] = values[0];
    selectedVariationId = null;
    selectedVariations[keyValue] = values;
    List<ProductVariation> notAllowedVariation = [];
    List<ProductVariation> allowedvariations = [];

    //allowed variations
    if (selectedVariationsValues.isNotEmpty) {
      if (widget.productVariations!.any((element) =>
          element.options["$keyValue"] == selectedVariationsValues[keyValue])) {
        allowedvariations = widget.productVariations!
            .where((element) =>
                element.options["$keyValue"] ==
                selectedVariationsValues[keyValue])
            .toList();

        // match allowed and selected variations
        if (allowedvariations.isNotEmpty) {
          selectedVariationsValues.forEach((key, value) {
            if (key != keyValue) {
              if (allowedvariations
                  .every((element) => !element.options.containsValue(value))) {
                selectedVariationsValues = clearSelectedVariation(key);
              }
              if (selectedVariationsValues.isNotEmpty) {
                selectedVariations.clear();
                selectedVariationsValues.forEach((key, value) {
                  selectedVariations[key] = [value];
                });

                variationControllers.forEach((key, value) {
                  if (!selectedVariations.containsKey(key)) {
                    variationControllers[key]!.reset!();
                  }
                });
              }
            }
          });
        }
      }
    }

    // not allowed variation
    if (widget.productVariations != null) {
      notAllowedVariation = widget.productVariations!.where((element) {
        bool matched = false;
        for (var key in selectedVariationsValues.keys) {
          if (element.options["$key"] != selectedVariationsValues[key]) {
            matched = true;
          }
        }
        return matched;
      }).toList();
    }

    // disabled variations
    if (notAllowedVariation.isNotEmpty) {
      disabledVariations = {};

      variations.forEach((attribute, attributeValue) {
        List<int> disbled = [];
        for (var variation in notAllowedVariation) {
          variation.options.forEach((key1, value1) {
            if (allowedvariations
                .every((element) => !element.options.containsValue(value1))) {
              disbled.add(value1);
            }
          });
        }
        disabledVariations[attribute.id!] = disbled.toSet().toList();
      });
    }

    if (selectedVariationsValues.isNotEmpty) {
      maxItems = -1;
      if (widget.productVariations != null &&
          widget.productVariations!.isNotEmpty &&
          widget.productVariations!.any((element) {
            List<bool> matched = [];

            if (selectedVariationsValues.length == element.options.length) {
              for (var key in selectedVariationsValues.keys) {
                if (element.options["$key"] == selectedVariationsValues[key]) {
                  matched.add(true);
                } else {
                  matched.add(false);
                }
              }
            }

            return matched.isNotEmpty &&
                    matched.length > 1 &&
                    matched.every((element) => element == true)
                ? true
                : false;
          })) {
        selectedVariationId = widget.productVariations!.firstWhere((v) {
          List<bool> matched = [];

          if (selectedVariationsValues.length == v.options.length) {
            for (var key in selectedVariationsValues.keys) {
              if (v.options["$key"] == selectedVariationsValues[key]) {
                matched.add(true);
              } else {
                matched.add(false);
              }
            }
          }

          return matched.isNotEmpty &&
                  matched.length > 1 &&
                  matched.every((element) => element == true)
              ? true
              : false;
        }).id!;
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
      mediaList = [];
    } else {
      maxItems = -1;
      mainMediaUpdate = false;
      gallery = widget.product.gallery;
    }

    setState(() {});
  }

  onQuantityChange(int count) {
    quantity = count;
  }

  @override
  Widget build(BuildContext context) {
    try {
      return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (attributes.isEmpty) {
            if (state.attributes != null && state.attributes!.isNotEmpty) {
              attributes = state.attributes!;
            }
          }
          if (attributeValues.isEmpty) {
            if (state.attributeValues != null &&
                state.attributeValues!.isNotEmpty) {
              attributeValues = state.attributeValues!;
            }
          }
          if (attributeSwatches.isEmpty) {
            if (state.attributeSwatches != null &&
                state.attributeSwatches!.isNotEmpty) {
              attributeSwatches = state.attributeSwatches!;
            }
          }

          if (widget.productVariations != null) {
            List<int> attributeValueList = [];
            for (var element in widget.productVariations!) {
              element.options.forEach((key, value) {
                attributeValueList.add(value);
              });
            }
            attributeValueList = attributeValueList.toSet().toList();
            for (var attribute in attributes) {
              List<AttributeValue> values = [];
              for (var item in attributeValueList) {
                if (attributeValues.any((element) =>
                    element.id == item &&
                    element.attribute ==
                        attributes
                            .where((element) => element.id == attribute.id)
                            .first
                            .id)) {
                  values.add(attributeValues
                      .where((element) => element.id == item)
                      .first);
                }
                variations[attribute] = values;
              }
            }
          }

          if (gallery == 0) {
            gallery = widget.product.gallery;
          }

          if (variationControllers.isEmpty) {
            for (var element in variations.keys) {
              variationControllers[element.id!] = VariationController();
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
                          DottedLine(
                              dashColor: UpConfig.of(context)
                                  .theme
                                  .baseColor
                                  .shade900),
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
                            visible: variations.isNotEmpty,
                            child: Column(
                              children: [
                                ...variations.keys.map((key) {
                                  if (attributeSwatches.any(
                                      (element) => element.id == key.swatch)) {
                                    AttributeSwatch swatch = attributeSwatches
                                        .where((element) =>
                                            element.id == key.swatch)
                                        .first;

                                    if (swatch.name.toLowerCase() == "color") {
                                      return Wrap(
                                        children: [
                                          variations.isNotEmpty
                                              ? UpText("${key.name} : ")
                                              : const UpText(""),
                                          ColorVariationWidget(
                                            selectedValues:
                                                selectedVariations[key.id],
                                            controller:
                                                variationControllers[key.id],
                                            disabledValues:
                                                disabledVariations[key.id!],
                                            colorVariations: variations[key],
                                            onChange: (c) =>
                                                onVariationChange(key.id!, c),
                                            mode: VariationSelectionMode.choose,
                                          ),
                                        ],
                                      );
                                    } else if (swatch.name.toLowerCase() ==
                                        "button") {
                                      return Wrap(
                                        children: [
                                          UpText("${key.name} : "),
                                          SizeVariationWidget(
                                            selectedValues:
                                                selectedVariations[key.id],
                                            disabledValues:
                                                disabledVariations[key.id!],
                                            sizeVariations: variations[key],
                                            controller:
                                                variationControllers[key.id],
                                            onChange: (c) =>
                                                onVariationChange(key.id!, c),
                                            mode: VariationSelectionMode.choose,
                                          ),
                                        ],
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                }).toList(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const UpText("Quantity:  "),
                              maxItems == -1
                                  ? const UpText(
                                      "Please select all variations first")
                                  : maxItems > 0
                                      ? Row(
                                          children: [
                                            Counter(
                                              defaultValue: defaultValue,
                                              onChange: onQuantityChange,
                                              maxItems: maxItems,
                                            ),
                                            // UpText("only $maxItems Items left"),
                                          ],
                                        )
                                      : UpText("OUT OF STOCK",
                                          style: UpStyle(textSize: 12))
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
                                            content: UpText(
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
                                            content: UpText(
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
                                            content: UpText(
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
                                            content: UpText('Select quantity '),
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

class ButtonWidget extends StatefulWidget {
  final Function onVariationChange;
  final Attribute attribute;
  final Map<int, List<int>> disabledValues;
  final Map<Attribute, List<AttributeValue>> variations;
  const ButtonWidget(
      {Key? key,
      required this.disabledValues,
      required this.attribute,
      required this.variations,
      required this.onVariationChange})
      : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    widget.disabledValues;
    return Wrap(
      children: [
        UpText("${widget.attribute.name} : "),
        SizeVariationWidget(
          // selectedValues: ,
          disabledValues: widget.disabledValues[widget.attribute.id!],
          sizeVariations: widget.variations[widget.attribute],
          onChange: (c) => widget.onVariationChange(c),
          mode: VariationSelectionMode.choose,
        ),
      ],
    );
  }
}

Widget _productDetais(Product product, BuildContext context) {
  return ExpansionTile(
    title: const UpText("Product Details"),
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: UpText("Description: ${product.description}"),
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: UpText("Fabric: cotton"),
        ),
      ),
    ],
  );
}

Widget ourServices(BuildContext context) {
  return Wrap(spacing: 10.0, children: [
    Container(
      color: Colors.white30,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fire_truck, size: 40),
              UpText(
                "Shipping Charges",
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, top: 0, bottom: 10),
            child: UpText(
              "Flat Rs. 200 on all orders ",
            ),
          )
        ],
      ),
    ),
    Container(
      color: Colors.white30,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hourglass_bottom, size: 40),
              UpText(
                "Support 24/7",
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, top: 0, bottom: 10),
            child: UpText(
              "Contact us 24/7 hours",
            ),
          )
        ],
      ),
    ),
    Container(
      color: Colors.white30,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pin_drop, size: 40),
              UpText(
                "Track Your Order",
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, top: 0, bottom: 10),
            child: UpText(
              "track your order for quick updates",
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
              child: const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
