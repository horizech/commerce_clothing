import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_swatch.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/services/attribute_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/variations/color_variation.dart';
import 'package:shop/widgets/variations/size_variation.dart';
import 'package:shop/widgets/variations/variation_controller.dart';
import 'package:shop/widgets/variations/variation_selection_mode.dart';

class FilterPage extends StatefulWidget {
  final int? collection;
  final Function? change;
  final List<dynamic> attributeValueList;
  const FilterPage({
    Key? key,
    this.collection,
    required this.attributeValueList,
    this.change,
  }) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<Attribute> attributes = [];
  List<Attribute> selectedAttributes = [];

  List<AttributeSwatch> attributeSwatches = [];

  List<AttributeValue> attributeValues = [];
  List<dynamic> attributeValueList = [];
  Map<Attribute, List<AttributeValue>> variations = {};
  // List<AttributeValue> sizeVariations = [];
  // List<AttributeValue> colorVariations = [];

  @override
  void initState() {
    super.initState();
    if (widget.attributeValueList.isEmpty) {
      getFilters();
    } else {
      attributeValueList = widget.attributeValueList;
    }
  }

  getFilters() async {
    if (widget.collection != null) {
      attributeValueList =
          await AttributeService.getAttributeValuesByCollection(
              widget.collection!);

      if (attributeValueList.isNotEmpty) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return attributeValueList.isNotEmpty
        ? BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state.attributes != null && state.attributes!.isNotEmpty) {
                attributes = state.attributes!.toList();
              }
              if (state.attributeValues != null &&
                  state.attributeValues!.isNotEmpty) {
                attributeValues = state.attributeValues!.toList();
              }
              if (state.attributeSwatches != null &&
                  state.attributeSwatches!.isNotEmpty) {
                attributeSwatches = state.attributeSwatches!.toList();
              }
              // if (sizeVariations.isEmpty) {
              //   if (attributeValueList.isNotEmpty) {
              //     for (var list in attributeValueList) {
              //       if (attributeValues.any((element) =>
              //           element.id == list["AttributeValues"] &&
              //           element.attribute ==
              //               attributes
              //                   .where((element) => element.name == "Size")
              //                   .first
              //                   .id)) {
              //         sizeVariations.add(attributeValues
              //             .where((element) =>
              //                 element.id == list["AttributeValues"])
              //             .first);
              //       } else if (attributeValues.any((element) =>
              //           element.id == list["AttributeValues"] &&
              //           element.attribute ==
              //               attributes
              //                   .where((element) => element.name == "Color")
              //                   .first
              //                   .id)) {
              //         colorVariations.add(attributeValues
              //             .where((element) =>
              //                 element.id == list["AttributeValues"])
              //             .first);
              //       }
              //     }
              //   }
              // }

              if (attributes.isNotEmpty) {
                for (var attribute in attributes) {
                  List<AttributeValue> values = [];
                  for (var list in attributeValueList) {
                    if (attributeValues.any((element) =>
                        element.id == list["AttributeValues"] &&
                        element.attribute ==
                            attributes
                                .where((element) => element.id == attribute.id)
                                .first
                                .id)) {
                      values.add(attributeValues
                          .where((element) =>
                              element.id == list["AttributeValues"])
                          .first);
                    }
                    variations[attribute] = values;
                  }
                }
              }
              variations;

              return Visibility(
                visible: variations.isNotEmpty,
                child: Column(
                  children: [
                    VariationFilter(
                        change: (selectedVariation) {
                          if (widget.change != null) {
                            widget.change!(
                                selectedVariation, attributeValueList);
                          }
                        },
                        variations: variations,
                        attributes: attributes,
                        attributeSwatches: attributeSwatches),
                  ],
                ),
              );
            },
          )
        : const SizedBox(
            width: 200,
            height: 10,
            child: SizedBox(),
          );
  }
}

class VariationFilter extends StatefulWidget {
  final Map<Attribute, List<AttributeValue>> variations;
  final List<Attribute> attributes;
  final List<AttributeSwatch> attributeSwatches;

  final Function? change;
  const VariationFilter(
      {Key? key,
      required this.variations,
      required this.attributes,
      required this.attributeSwatches,
      this.change})
      : super(key: key);

  @override
  State<VariationFilter> createState() => _VariationFilterState();
}

class _VariationFilterState extends State<VariationFilter> {
  Map<int, List<int>> selectedVariationsValues = {};
  Map<int, VariationController> variationControllers = {};

  onVariationChange(int? key, List<int> values) {
    debugPrint("you clicked on $values for $key");
    setState(() {
      selectedVariationsValues[key!] = values;
    });
  }

  onChange() {
    widget.change!(selectedVariationsValues);
  }

  onReset() {
    variationControllers.values
        .toList()
        .forEach((controller) => controller.reset!());

    setState(() {
      selectedVariationsValues.clear();
      widget.change!(selectedVariationsValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (variationControllers.isEmpty) {
    //   for (var element in VariationTypes.values) {
    //     variationControllers[element.index] = VariationController();
    //   }
    // }

    if (selectedVariationsValues.isEmpty) {
      for (var element in widget.attributes) {
        selectedVariationsValues[element.id!] = [];
      }
    }

    return Column(
      children: [
        ...widget.variations.keys.map((key) {
          if (widget.attributeSwatches
              .any((element) => element.id == key.swatch)) {
            AttributeSwatch swatch = widget.attributeSwatches
                .where((element) => element.id == key.swatch)
                .first;

            if (swatch.name.toLowerCase() == "color") {
              return Wrap(
                children: [
                  widget.variations.isNotEmpty
                      ? UpText("${key.name} : ")
                      : const UpText(""),
                  ColorVariationWidget(
                    colorVariations: widget.variations[key],
                    onChange: (c) => onVariationChange(key.id, c),
                    mode: VariationSelectionMode.filter,
                    // controller:
                    //     variationControllers[VariationTypes.color.index],
                  ),
                ],
              );
            } else if (swatch.name.toLowerCase() == "button") {
              return Wrap(
                children: [
                  widget.variations.isNotEmpty
                      ? UpText("${key.name} : ")
                      : const UpText(""),
                  SizeVariationWidget(
                    sizeVariations: widget.variations[key],
                    onChange: (c) => onVariationChange(key.id, c),
                    mode: VariationSelectionMode.filter,
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

        // Wrap(
        //   children: [
        //     widget.variations.isNotEmpty
        //         ? const UpText("Sizes : ")
        //         : const UpText(""),
        //     SizeVariationWidget(
        //       sizeVariations: widget.sizeVariations,
        //       onChange: (s) => onVariationChange(VariationTypes.size.index, s),
        //       mode: VariationSelectionMode.filter,
        //       controller: variationControllers[VariationTypes.size.index],
        //     ),
        //   ],
        // ),

        // ColorVariationWidget(
        //   colorVariations: widget.colorVariations,
        //   onChange: (c) =>
        //       onVariationChange(VariationTypes.color.index, c),
        //   mode: VariationSelectionMode.filter,
        //   controller: variationControllers[VariationTypes.color.index],
        // ),

        // GestureDetector(
        //   onTap: onReset,
        //   child: const Wrap(
        //     crossAxisAlignment: WrapCrossAlignment.center,
        //     runAlignment: WrapAlignment.center,
        //     children: [
        //       Padding(padding: EdgeInsets.all(10.0)),
        //       Icon(
        //         Icons.delete_outline,
        //         size: 30,
        //       ),
        //       UpText("Clear Filters"),
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: onReset,
                child: UpButton(
                  onPressed: () {},
                  text: "Clear Filters",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              UpButton(
                onPressed: onChange,
                text: "Apply Filter",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
