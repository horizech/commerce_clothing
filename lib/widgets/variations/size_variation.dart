import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/attribute_value.dart';
import 'package:shop/widgets/variations/variation_controller.dart';
import 'package:shop/widgets/variations/variation_selection_mode.dart';

class SizeVariationWidget extends StatefulWidget {
  final List<AttributeValue>? sizeVariations;
  final Function? onChange;
  final List<int>? selectedValues;
  final List<int>? disabledValues;
  final VariationSelectionMode mode;
  final VariationController? controller;
  const SizeVariationWidget(
      {Key? key,
      this.sizeVariations,
      this.onChange,
      this.selectedValues,
      this.disabledValues,
      this.mode = VariationSelectionMode.choose,
      this.controller})
      : super(key: key);

  @override
  State<SizeVariationWidget> createState() => _SizeVariationWidgetState();
}

class _SizeVariationWidgetState extends State<SizeVariationWidget> {
  List<int> selectableVariations = [];
  List<int> currentSelections = [];
  List<int> newSelections = [];

  reset() {
    currentSelections.clear();
    newSelections.clear();
    debugPrint("reset");
    setState(() {
      currentSelections = [];
    });
  }

  changeSelection(int id) {
    if (widget.mode == VariationSelectionMode.cart) {
      return;
    }

    newSelections = [...currentSelections];
    bool needsUpdate = false;

    if (widget.mode == VariationSelectionMode.choose) {
      if (!currentSelections.contains(id)) {
        newSelections = [id];
        needsUpdate = true;
      }
    } else if (widget.mode == VariationSelectionMode.filter) {
      if (currentSelections.contains(id)) {
        newSelections.remove(id);
      } else {
        newSelections.add(id);
      }
      needsUpdate = true;
    }

    if (needsUpdate) {
      // changeSelection(entry.key, entry.value);

      widget.onChange!(newSelections);
      setState(() {
        currentSelections = newSelections;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller != null) {
      widget.controller!.reset = reset;
    }
    if (selectableVariations.isEmpty) {
      selectableVariations = (widget.mode == VariationSelectionMode.cart)
          ? widget.selectedValues ?? []
          : (widget.sizeVariations ?? []).map((s) => s.id!).toList();
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 5.0,
            runSpacing: 5.0,
            children: [
              Wrap(
                  spacing: 5.0,
                  runSpacing: 5.0,
                  children: selectableVariations
                      .asMap()
                      .entries
                      .map(
                        (entry) => GestureDetector(
                          onTap: () {
                            changeSelection(entry.value);
                            // if (widget.disabledValues == null ||
                            //     !widget.disabledValues!.contains(entry.value)) {
                            //   changeSelection(entry.value);
                            // }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: (widget.selectedValues ??
                                            currentSelections)
                                        .contains(entry.value)
                                    ? UpThemes.getContrastColor(
                                        UpConfig.of(context).theme.baseColor)
                                    : (widget.disabledValues != null &&
                                            widget.disabledValues!
                                                .contains(entry.value))
                                        ? Colors.grey
                                        : UpConfig.of(context)
                                            .theme
                                            .primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  (widget.selectedValues ?? currentSelections)
                                          .contains(entry.value)
                                      ? UpConfig.of(context).theme.primaryColor
                                      : (widget.disabledValues != null &&
                                              widget.disabledValues!
                                                  .contains(entry.value))
                                          ? Colors.grey[200]
                                          : Colors.transparent,
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: UpText(
                                widget.sizeVariations!
                                    .firstWhere(
                                        (element) => element.id == entry.value)
                                    .name,
                                style:
                                    (widget.selectedValues ?? currentSelections)
                                            .contains(entry.value)
                                        ? UpStyle(
                                            textSize: 12,
                                            textColor:
                                                UpThemes.getContrastColor(
                                                    UpConfig.of(context)
                                                        .theme
                                                        .baseColor))
                                        : (widget.disabledValues != null &&
                                                widget.disabledValues!
                                                    .contains(entry.value))
                                            ? UpStyle(
                                                iconSize: 12,
                                                textColor:
                                                    UpThemes.getContrastColor(
                                                        UpConfig.of(context)
                                                            .theme
                                                            .baseColor),
                                              )
                                            : UpStyle(
                                                iconSize: 12,
                                                textColor:
                                                    UpThemes.getContrastColor(
                                                        UpConfig.of(context)
                                                            .theme
                                                            .baseColor)),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ],
          ),
        ),
      ),
    );
  }
}
