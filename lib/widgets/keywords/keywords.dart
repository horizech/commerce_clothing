import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/widgets/keywords/keyword_selector.dart';
import 'package:shop/widgets/keywords/keywords_service.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class Keywords extends StatefulWidget {
  final int? categoryId;
  final Function? onChange;
  final int? selectedKeywordId;

  const Keywords({
    Key? key,
    this.onChange,
    this.selectedKeywordId,
    this.categoryId,
  }) : super(key: key);

  @override
  State<Keywords> createState() => _KeywordsState();
}

class _KeywordsState extends State<Keywords> {
  List<int> keywordsList = [];

  @override
  Widget build(BuildContext context) {
    if (keywordsList.isNotEmpty) {
      return _keywordsWrap(
          context, widget.onChange, widget.selectedKeywordId, keywordsList);
    }
    return FutureBuilder<List<int>>(
      future: KeywordsService.getKeywordsList(widget.categoryId),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.grey[100],
            child: Column(
              children: const [],
            ),
          );
        }
        keywordsList = snapshot.data ?? [];
        if (keywordsList != [] && keywordsList.isNotEmpty) {
          return _keywordsWrap(
              context, widget.onChange, widget.selectedKeywordId, keywordsList);
        }
        return const Text("");
      },
    );
  }
}

Widget _keywordsWrap(BuildContext context, Function? onChange,
    int? selectedKeywordId, List<int> keywordsList) {
  return Wrap(
    runAlignment: WrapAlignment.start,
    crossAxisAlignment: WrapCrossAlignment.start,
    spacing: 5.0,
    runSpacing: 5.0,
    children: [
      KeywordSelector(
          onChange: onChange,
          keyword: const Keyword(id: -1, name: "All"),
          isSelected: (selectedKeywordId ?? -1) == -1),
      ...keywordsList
          .toList()
          .map((entry) => _keywords(
              entry, onChange, entry == (selectedKeywordId ?? -1), context))
          .toList(),
    ],
  );
}

Widget _keywords(
    int? keywordId, Function? onChange, bool isSelected, BuildContext context) {
  Keyword keywords;
  return BlocConsumer<StoreCubit, StoreState>(
    listener: (context, state) {},
    builder: (context, state) {
      keywords = state.keywords!.where((k) => (k.id == keywordId)).first;
      return KeywordSelector(
        onChange: onChange,
        keyword: keywords,
        isSelected: isSelected,
      );
    },
  );
}
