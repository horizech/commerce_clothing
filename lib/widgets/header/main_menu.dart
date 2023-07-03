import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/collection_tree.dart';
import 'package:shop/models/collection_tree_item.dart';
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: (tree.roots![parent].children ?? [])
            .map(
              (e) => Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
                    child: GestureDetector(
                      child: Column(
                        children: [
                          UpText(
                            e.name,
                          ),
                        ],
                      ),
                      onTap: () {
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.products, queryParams: {
                          'collection': '${e.id}',
                        });

                        // print('Clicked');
                      },
                    ),
                  ),
                  getcolumn(e.children)
                ],
              ),
            )
            .toList(),
      )
    ].toList();
  }

  Widget getcolumn(List<CollectionTreeItem>? collections) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: collections != null
            ? collections
                .map((e) => GestureDetector(
                      onTap: () {
                        ServiceManager<UpNavigationService>().navigateToNamed(
                          Routes.products,
                          queryParams: {'collection': '${e.id}'},
                        );

                        // print('Clicked');
                      },
                      child: UpText(
                        e.name,
                      ),
                    ))
                .toList()
            : [const Text("")],
      ),
    );
  }
  // getMenu(int index) {
  //   collectionTree!.roots!
  //                       .map(
  //                         (e) =>
  //                             // DropdownButton(
  //                             //     isExpanded: true,
  //                             //     items: const [
  //                             //       DropdownMenuItem(child: Text("Abc")),
  //                             //       DropdownMenuItem(child: Text("Xyz")),
  //                             //     ],
  //                             //     hint: const Text("Select City"),
  //                             //     onChanged: null),
  //                             TextButton(
  //                           style: const ButtonStyle(),
  //                           focusNode: rootFocusNodes[index],
  //                           onHover: (val) {
  //                             if (val) {
  //                               rootFocusNodes[index].requestFocus();
  //                               showOverlay = true;
  //                               initializeOverLayWidgets(context, e.children);
  //                             }
  //                           },
  //                           onPressed: () {},
  //                           child: Column(
  //                             children: [
  //                               Text(e.name,
  //                                   style:
  //                                       Theme.of(context).textTheme.headline6),
  //                             ],
  //                           ),
  //                         ),
  //                       )
  //                       .toList())

  // }

  getWidgets(BuildContext context, CollectionTree tree, int index) => [
        Stack(
          children: [
            ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 512,
                  decoration: BoxDecoration(
                    color: UpConfig.of(context).theme.baseColor.shade50,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                        spreadRadius: 0.4,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12),
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
            left: MediaQuery.of(context).size.width * 0.1,
            // index == 0
            //     ? MediaQuery.of(context).size.width * 0.43
            //     : MediaQuery.of(context).size.width * 0.5,
            top: 112,
            // top: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.8,
            height: 512,
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
    // overlayState!.insert(overlayEntry!);
    overlayState!.insertAll([overlayEntry!]);
  }

  void removeOverlay() {
    overlayEntry!.remove();
  }

  @override
  void initState() {
    super.initState();
    // for (int index in [0, 1]) {
    //   if (rootFocusNodes.length - 1 < index) {
    //     rootFocusNodes.add(FocusNode());
    //     rootFocusNodes[index].addListener(() {
    //       if (rootFocusNodes[index].hasFocus) {
    //         _showOverlay(context, index);
    //       } else {
    //         removeOverlay();
    //       }
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoreCubit, StoreState>(
        listener: (context, state) {},
        builder: (context, state) {
          // CollectionTree? collectionTree = state.collectionTree;
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
                          // onHover: (val) {
                          //   rootFocusNodes[entry.key].requestFocus();
                          //   showOverlay = true;
                          // },
                          child: TextButton(
                            focusNode: rootFocusNodes[entry.key],
                            onHover: (val) {
                              if (val) {
                                rootFocusNodes[entry.key].requestFocus();
                                showOverlay = true;
                              }
                            },
                            onPressed: () {},
                            child: Text(entry.value.name),
                          ),
                        ))
                    .toList()
                //  [
                //   TextButton(
                //     focusNode: rootFocusNodes[0],
                //     onHover: (val) {
                //       if (val) {
                //         rootFocusNodes[0].requestFocus();
                //         showOverlay = true;
                //       }
                //     },
                //     onPressed: () {},
                //     child: const Text('Hover 1'),
                //   ),
                //   TextButton(
                //     focusNode: rootFocusNodes[1],
                //     onHover: (val) {
                //       if (val) {
                //         rootFocusNodes[1].requestFocus();
                //         showOverlay = true;
                //       }
                //     },
                //     onPressed: () {},
                //     child: const Text('Hover 2'),
                //   ),
                // ],
                ),
          );
        });
  }
}
