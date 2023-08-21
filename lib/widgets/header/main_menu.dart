import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/widgets/up_orientational_column_row.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection_tree.dart';
import 'package:shop/models/collection_tree_item.dart';
import 'package:shop/widgets/media/media_widget.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  bool showOverlay = false;

  final layerLink = LayerLink();
  final List<FocusNode> rootFocusNodes = [];

  final List<Widget> row = [];

  getRow({int level = 0, required CollectionTree tree, required int parent}) {
    return [
      UpOrientationalColumnRow(
          widths: const [350, -1],
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 350,
                width: 300,
                child: MediaWidget(mediaId: tree.roots![parent].media),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Wrap(
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.spaceBetween,
                children: (tree.roots![parent].children ?? [])
                    .map(
                      (e) => SizedBox(
                        width: 250,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            children: [
                              Container(
                                // constraints: const BoxConstraints(minWidth: 250),

                                margin: const EdgeInsets.fromLTRB(0, 16, 8, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    child: Column(
                                      children: [
                                        UpText(
                                          style: UpStyle(
                                            textSize: 16,
                                            textWeight: FontWeight.bold,
                                          ),
                                          e.name,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      ServiceManager<UpNavigationService>()
                                          .navigateToNamed(Routes.products,
                                              queryParams: {
                                            'collection': '${e.id}',
                                          });
                                      removeOverlay();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Divider(
                                color: UpConfig.of(context)
                                    .theme
                                    .baseColor
                                    .shade400,
                                height: 2,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: getcolumn(e.children))
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ].toList())
    ];
  }

  Widget getcolumn(List<CollectionTreeItem>? collections) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: collections != null
            ? collections
                .map((e) => Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          ServiceManager<UpNavigationService>().navigateToNamed(
                            Routes.products,
                            queryParams: {'collection': '${e.id}'},
                          );
                          removeOverlay();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            style: TextStyle(
                                color: UpConfig.of(context)
                                    .theme
                                    .baseColor
                                    .shade800),
                            e.name,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ))
                .toList()
            : [const Text("")],
      ),
    );
  }

  getWidgets(BuildContext context, CollectionTree tree, int index) => [
        Stack(
          children: [
            ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  constraints: const BoxConstraints(minHeight: 400),
                  decoration: BoxDecoration(
                    color: UpConfig.of(context).theme.baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: UpConfig.of(context).theme.baseColor.shade300,
                        blurRadius: 5.0,
                        offset: const Offset(0, 10),
                        spreadRadius: 0.4,
                      ),
                    ],
                    border: Border(
                      bottom: BorderSide(
                        width: 2,
                        color: UpConfig.of(context).theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ...getRow(tree: tree, parent: index)
          ],
        ),
      ];

  void _showOverlay(
      BuildContext context, CollectionTree tree, int index) async {
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        maintainState: true,
        builder: (context) {
          return Positioned(
            top: 112,
            width: MediaQuery.of(context).size.width,
            height: 400,
            child: TextButton(
              onPressed: () {},
              onHover: (val) {
                if (val && showOverlay) {
                  rootFocusNodes[index].requestFocus();
                } else {
                  rootFocusNodes[index].unfocus();
                }
              },
              child: getWidgets(context, tree, index)[0],
            ),
          );
        });
    overlayState!.insertAll([overlayEntry!]);
  }

  void removeOverlay() {
    overlayEntry!.remove();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          rootFocusNodes.clear();
          for (int index = 0;
              index < state.collectionTree!.roots!.length;
              index++) {
            rootFocusNodes.add(FocusNode());
            rootFocusNodes[index].addListener(() {
              if (rootFocusNodes[index].hasFocus) {
                _showOverlay(context, state.collectionTree!, index);
              } else {
                removeOverlay();
              }
            });
          }
          return SizedBox(
            height: 100,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: state.collectionTree!.roots!
                    .asMap()
                    .entries
                    .map((entry) => MouseRegion(
                          onEnter: (event) => {
                            rootFocusNodes[entry.key].requestFocus(),
                            showOverlay = true,
                          },
                          onExit: (event) => {
                            rootFocusNodes[entry.key].unfocus(),
                          },
                          child: TextButton(
                            focusNode: rootFocusNodes[entry.key],

                            // onHover: (val) {
                            //   if (val) {
                            //     rootFocusNodes[entry.key].requestFocus();
                            //     showOverlay = true;
                            //   }
                            // },
                            onPressed: () {},
                            child: Text(entry.value.name),
                          ),
                        ))
                    .toList()),
          );
        });
  }
}
