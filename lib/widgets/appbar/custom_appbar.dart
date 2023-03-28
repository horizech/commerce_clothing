import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:shop/constants.dart';
import 'package:shop/widgets/search/search.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final int? collection;
  GlobalKey<ScaffoldState>? scaffoldKey;

  CustomAppbar({Key? key, this.collection, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return UpAppBar(
      excludeHeaderSemantics: true,
      automaticallyImplyLeading: false,
      title: "Shop",
      leading: width < 600
          ? IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                scaffoldKey!.currentState!.openDrawer();
              },
            )
          : const Text(""),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(collectionId: collection),
            );
          },
          icon: const Icon(Icons.search),
        ),
        Visibility(
          visible: !Apiraiser.authentication.isSignedIn(),
          child: IconButton(
            onPressed: () {
              ServiceManager<UpNavigationService>().navigateToNamed(
                Routes.loginSignup,
              );
            },
            icon: const Icon(Icons.person),
          ),
        ),
        IconButton(
          onPressed: () {
            ServiceManager<UpNavigationService>().navigateToNamed(
              Routes.cart,
            );
          },
          icon: const Icon(Icons.shopping_bag),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
