import 'package:flutter/material.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/models/keyword.dart';

class KeywordSelector extends StatefulWidget {
  final Function? onChange;
  final Keyword keyword;
  final bool isSelected;

  const KeywordSelector(
      {Key? key, this.onChange, this.isSelected = false, required this.keyword})
      : super(key: key);

  @override
  State<KeywordSelector> createState() => _KeywordSelectorState();
}

class _KeywordSelectorState extends State<KeywordSelector> {
  onChange(String value, int? id) {
    widget.onChange!(id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(widget.keyword.name, widget.keyword.id);
      },
      child: Chip(
        labelPadding: const EdgeInsets.only(
          left: 5,
          right: 5,
          top: 2,
          bottom: 2,
        ),
        label: UpText(
          widget.keyword.name,
          style: UpStyle(
              textColor: widget.isSelected
                  ? UpThemes.getContrastColor(
                      UpConfig.of(context).theme.primaryColor)
                  : UpConfig.of(context).theme.baseColor[900]),
        ),
        backgroundColor: widget.isSelected
            ? UpConfig.of(context).theme.primaryColor
            : UpConfig.of(context).theme.baseColor[200],
      ),
    );
  }
}
