import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:shop/models/attribute.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/services/attribute_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/variations/color_variation.dart';
import 'package:shop/widgets/variations/size_variation.dart';
import 'package:shop/widgets/variations/variation_controller.dart';
import 'package:shop/widgets/variations/variation_selection_mode.dart';
import 'package:shop/widgets/variations/variation_types.dart';

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
  List<AttributeValue> attributeValues = [];
  List<dynamic> attributeValueList = [];
  List<AttributeValue> sizeVariations = [];
  List<AttributeValue> colorVariations = [];

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
              if (sizeVariations.isEmpty) {
                if (attributeValueList.isNotEmpty) {
                  for (var list in attributeValueList) {
                    if (attributeValues.any((element) =>
                        element.id == list["AttributeValues"] &&
                        element.attribute ==
                            attributes
                                .where((element) => element.name == "Size")
                                .first
                                .id)) {
                      sizeVariations.add(attributeValues
                          .where((element) =>
                              element.id == list["AttributeValues"])
                          .first);
                    } else if (attributeValues.any((element) =>
                        element.id == list["AttributeValues"] &&
                        element.attribute ==
                            attributes
                                .where((element) => element.name == "Color")
                                .first
                                .id)) {
                      colorVariations.add(attributeValues
                          .where((element) =>
                              element.id == list["AttributeValues"])
                          .first);
                    }
                  }
                }
              }

              return Visibility(
                visible: (sizeVariations != [] && sizeVariations.isNotEmpty) ||
                    (colorVariations != [] && colorVariations.isNotEmpty),
                child: Column(
                  children: [
                    VariationFilter(
                      change: (selectedVariation) {
                        if (widget.change != null) {
                          widget.change!(selectedVariation, attributeValueList);
                        }
                      },
                      sizeVariations: sizeVariations,
                      colorVariations: colorVariations,
                    ),
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
  // int? category;
  List<AttributeValue>? sizeVariations;
  List<AttributeValue>? colorVariations;
  Function? change;
  VariationFilter(
      {Key? key, this.sizeVariations, this.colorVariations, this.change})
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
    if (variationControllers.isEmpty) {
      for (var element in VariationTypes.values) {
        variationControllers[element.index] = VariationController();
      }
    }

    if (selectedVariationsValues.isEmpty) {
      for (var element in VariationTypes.values) {
        selectedVariationsValues[element.index] = [];
      }
    }

    return Wrap(
      children: [
        Column(
          children: [
            Wrap(children: [
              widget.sizeVariations != null && widget.sizeVariations!.isNotEmpty
                  ? const Text("Sizes : ")
                  : const Text(""),
              SizeVariationWidget(
                sizeVariations: widget.sizeVariations,
                onChange: (s) =>
                    onVariationChange(VariationTypes.size.index, s),
                mode: VariationSelectionMode.filter,
                controller: variationControllers[VariationTypes.size.index],
              ),
            ]),
            Wrap(children: [
              widget.colorVariations != null &&
                      widget.colorVariations!.isNotEmpty
                  ? const Text("Colors : ")
                  : const Text(""),
              ColorVariationWidget(
                colorVariations: widget.colorVariations,
                onChange: (c) =>
                    onVariationChange(VariationTypes.color.index, c),
                mode: VariationSelectionMode.filter,
                controller: variationControllers[VariationTypes.color.index],
              ),
            ]),
            GestureDetector(
              onTap: onReset,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(10.0)),
                  const Icon(
                    Icons.delete_outline,
                    size: 30,
                  ),
                  Text(
                    "Clear Filters",
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: UpButton(
                onPressed: onChange,
                text: "Apply Filter",
              ),
            ),
          ],
        )
      ],
    );
  }
}
