import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/constants.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/models/collection_tree.dart';
import 'package:shop/models/collection_tree_item.dart';
import 'package:shop/models/collection_tree_node.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionTree? collectionTree;

    return BlocConsumer<StoreCubit, StoreState>(
      listener: (context, state) {},
      builder: (context, state) {
        collectionTree = state.collectionTree;
        List<TreeNode> nodes = collectionTree!.roots!
            .map(
              (e) => TreeNode(
                e,
                subNodes: e.children != null && e.children!.isNotEmpty
                    ? getTreeSubNodes(e) ?? []
                    : const [TreeNode("")],
              ),
            )
            .toList();
        return Drawer(
          backgroundColor: UpConfig.of(context).theme.baseColor,
          child: Column(
            children: [
              !isUserLogin()
                  ? GestureDetector(
                      onTap: () {
                        ServiceManager<UpNavigationService>()
                            .navigateToNamed(Routes.loginSignup);
                      },
                      child: Container(
                        color: UpConfig.of(context).theme.primaryColor,
                        height: 50,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            UpText(
                              "Login/SignUp",
                              style: UpStyle(
                                  textColor: UpThemes.getContrastColor(
                                      UpConfig.of(context).theme.primaryColor)),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              ExpandableTree(
                childrenMargin: const EdgeInsets.only(left: 1),
                childIndent: 0,
                initiallyExpanded: false,
                
                childrenDecoration:
                    BoxDecoration(color: UpConfig.of(context).theme.baseColor),
                submenuOpenColor: UpConfig.of(context).theme.primaryColor,
                submenuClosedColor: UpConfig.of(context).theme.baseColor,
                openTwistyColor: UpThemes.getContrastColor(
                    UpConfig.of(context).theme.primaryColor),
                closedTwistyColor: UpConfig.of(context).theme.primaryColor,
                nodes: nodes,
                nodeBuilder: (context, nodeValue) => Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
                  child: UpText(
                    (nodeValue as CollectionTreeItem)
                        .name
                        .toUpperCase()
                        .toString(),
                  ),
                ),
                onSelect: (node) {
                  ServiceManager<UpNavigationService>()
                      .navigateToNamed(Routes.products, queryParams: {
                    "collection": '${(node as CollectionTreeItem).id}',
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
            
            
            
//              Center(
//               child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: collectionTree!.roots!
//                       .map(
//                         (e) => Column(
//                           children: [
//                             ListTile(
//                               title: Text(
//                                 e.name,
//                                 style: Theme.of(context).textTheme.headline6,
//                               ),
//                               onTap: () {
//                                
//                               },
//                             ),
//                             childrenWidget(context, e)
//                           ],
//                         ),
//                       )
//                       .toList()),
//             ),
//           );
//         });
//   }
// }

// Widget childrenWidget(
//     BuildContext context, CollectionTreeItem collectionTreeItem) {
//   return Column(
//       children: collectionTreeItem.children != null
//           ? collectionTreeItem.children!
//               .map((e) => Text(
//                     e.name,
//                     style: Theme.of(context)
//                         .textTheme
//                         .headline6!
//                         .copyWith(color: Colors.white),
//                   ))
//               .toList()
//           : [const Text("")]);
// }
