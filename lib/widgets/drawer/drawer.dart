import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expandable_tree_menu/expandable_tree_menu.dart';
import 'package:shop/constants.dart';
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
          // backgroundColor: Colors.black,
          child: ExpandableTree(
            childIndent: 8,
            // twistyPosition: TwistyPosition.after,
            childrenDecoration: const BoxDecoration(color: Colors.transparent),
            submenuOpenColor: Colors.transparent,
            submenuClosedColor: Colors.transparent,
            submenuDecoration: const BoxDecoration(
              color: Colors.transparent,
              // border: Border.all(),
            ),
            submenuMargin: const EdgeInsets.all(3),
            childrenMargin: const EdgeInsets.all(3),
            openTwistyColor: Colors.black,
            closedTwistyColor: Colors.black,
            nodes: nodes,
            nodeBuilder: (context, nodeValue) => Text(
              (nodeValue as CollectionTreeItem).name.toString(),
              style: Theme.of(context).textTheme.headline6!.copyWith(
                  backgroundColor: Colors.transparent,
                  fontSize: 14,
                  color: Colors.black),
            ),
            onSelect: (node) {
              ServiceManager<UpNavigationService>()
                  .navigateToNamed(Routes.products, queryParams: {
                "collection": '${(node as CollectionTreeItem).id}',
              });
            },
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
