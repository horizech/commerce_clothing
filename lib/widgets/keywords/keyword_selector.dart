import 'package:flutter/material.dart';
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
          right: 2,
          top: 2,
          bottom: 2,
        ),
        label: Text(
          widget.keyword.name,
          style: TextStyle(
              color: widget.isSelected
                  ? Colors.white
                  : Theme.of(context).primaryColor),
        ),
        backgroundColor: widget.isSelected
            ? Theme.of(context).primaryColor
            : Colors.grey[100],
      ),
    );
  }
}
