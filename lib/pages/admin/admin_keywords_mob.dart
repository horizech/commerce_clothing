import 'package:apiraiser/apiraiser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/helpers/up_toast.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_button.dart';
import 'package:flutter_up/widgets/up_card.dart';
import 'package:flutter_up/widgets/up_list_tile.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:shop/is_user_admin.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:flutter_up/widgets/up_textfield.dart';
import 'package:shop/dialogs/delete_dialog.dart';
import 'package:shop/models/keyword.dart';
import 'package:shop/services/add_edit_product_service/add_edit_product_service.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/store/store_cubit.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class AdminKeywordsMob extends StatefulWidget {
  const AdminKeywordsMob({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminKeywordsMob> createState() => _AdminKeywordsMobState();
}

class _AdminKeywordsMobState extends State<AdminKeywordsMob> {
  List<Keyword> keywords = [];
  TextEditingController nameController = TextEditingController();
  Keyword selectedKeyword = const Keyword(name: "", id: -1);
  @override
  void initState() {
    super.initState();
  }

  getKeywords() async {
    keywords = await AddEditProductService.getKeywords();
    setState(() {});
  }

  _updateKeyword(Keyword? k) async {
    Keyword keyword = Keyword(
      name: nameController.text,
    );
    APIResult? result = await AddEditProductService.addEditkeyword(
        data: Keyword.toJson(keyword), keywordId: k != null ? k.id! : null);
    if (result != null && result.success) {
      if (mounted) {
        UpToast().showToast(
          context: context,
          text: result.message ?? "",
        );
      }
      getKeywords();
    } else {
      if (mounted) {
        UpToast().showToast(
          context: context,
          text: "An Error Occurred",
        );
      }
    }
  }

  _deleteKeyword(int keywordId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const DeleteDialog();
      },
    ).then((result) async {
      if (result == "success") {
        APIResult? result =
            await AddEditProductService.deleteKeyword(keywordId);
        if (result != null && result.success) {
          if (mounted) {
            UpToast().showToast(context: context, text: result.message ?? "");
          }
          selectedKeyword = const Keyword(name: "", id: -1);
          nameController.text = "";
          getKeywords();
        } else {
          if (mounted) {
            UpToast().showToast(
              context: context,
              text: "An Error Occurred",
            );
          }
        }
      }
    });
  }

  Widget leftSide() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: UpCard(
        style: UpStyle(cardWidth: 310, cardBodyPadding: false),
        body: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              GestureDetector(
                  onTap: (() {
                    selectedKeyword = const Keyword(name: "", id: -1);
                    nameController.text = selectedKeyword.name;
                    Navigator.pop(context);
                    setState(() {});
                  }),
                  child: Container(
                    color: selectedKeyword.id == -1
                        ? UpConfig.of(context).theme.primaryColor
                        : Colors.transparent,
                    child: UpListTile(
                      title: ("Create a new keyword"),
                      style: UpStyle(
                        listTileTextColor: selectedKeyword.id == -1
                            ? UpThemes.getContrastColor(
                                UpConfig.of(context).theme.primaryColor)
                            : UpConfig.of(context).theme.baseColor.shade900,
                      ),
                    ),
                  )),
              ...keywords
                  .map(
                    (e) => GestureDetector(
                      onTap: (() {
                        selectedKeyword = e;
                        nameController.text = selectedKeyword.name;
                        Navigator.pop(context);
                        setState(() {});
                      }),
                      child: Container(
                        color: selectedKeyword.id == e.id
                            ? UpConfig.of(context).theme.primaryColor
                            : Colors.transparent,
                        child: UpListTile(
                          title: (e.name),
                          style: UpStyle(
                            listTileTextColor: selectedKeyword.id == e.id
                                ? UpThemes.getContrastColor(
                                    UpConfig.of(context).theme.primaryColor)
                                : UpConfig.of(context).theme.baseColor.shade900,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: UpAppBar(
        style: UpStyle(
            iconColor: UpThemes.getContrastColor(
                UpConfig.of(context).theme.primaryColor)),
      ),
      drawer: const NavDrawer(),
      endDrawer: SafeArea(
        child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Drawer(
            child: leftSide(),
          );
        }),
      ),
      body: isUserAdmin()
          ? BlocConsumer<StoreCubit, StoreState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (keywords.isEmpty) {
                  if (state.keywords != null && state.keywords!.isNotEmpty) {
                    keywords = state.keywords!.toList();
                  }
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        UpCard(
                          style: UpStyle(
                              cardWidth: MediaQuery.of(context).size.width - 32,
                              cardBodyPadding: false,
                              cardRadius: 8),
                          header: Center(
                            child: UpText(
                              selectedKeyword.id == -1
                                  ? "Add keyword"
                                  : "Update keyword",
                              style: UpStyle(
                                  textSize: 24,
                                  textFontStyle: FontStyle.italic),
                            ),
                          ),
                          body: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            width: 300,
                                            child: UpTextField(
                                              controller: nameController,
                                              label: 'Name',
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Visibility(
                                              visible: selectedKeyword.id != -1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 70,
                                                  height: 30,
                                                  child: UpButton(
                                                    onPressed: () {
                                                      _deleteKeyword(
                                                          selectedKeyword.id!);
                                                    },
                                                    text: "Delete",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: 70,
                                                height: 30,
                                                child: UpButton(
                                                  onPressed: () {
                                                    _updateKeyword(
                                                        selectedKeyword.id != -1
                                                            ? selectedKeyword
                                                            : null);
                                                  },
                                                  text: "Save",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const UnAuthorizedWidget(),
    );
  }
}
