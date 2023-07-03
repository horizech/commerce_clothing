import 'package:apiraiser/apiraiser.dart';
import 'package:flutter_up/config/up_config.dart';
import 'package:flutter_up/locator.dart';
import 'package:flutter_up/services/up_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_up/themes/up_style.dart';
import 'package:flutter_up/themes/up_themes.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_icon.dart';
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
              icon: UpIcon(
                  icon: Icons.menu,
                  style: UpStyle(
                      iconColor: UpThemes.getContrastColor(
                          UpConfig.of(context).theme.primaryColor),
                      iconSize: 25)),
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
          icon: UpIcon(
              icon: Icons.search,
              style: UpStyle(
                  iconColor: UpThemes.getContrastColor(
                      UpConfig.of(context).theme.primaryColor))),
        ),
        Visibility(
          visible: !Apiraiser.authentication.isSignedIn(),
          child: IconButton(
            onPressed: () {
              ServiceManager<UpNavigationService>().navigateToNamed(
                Routes.loginSignup,
              );
            },
            icon: UpIcon(
                icon: Icons.person,
                style: UpStyle(
                    iconColor: UpThemes.getContrastColor(
                        UpConfig.of(context).theme.primaryColor))),
          ),
        ),
        IconButton(
          onPressed: () {
            ServiceManager<UpNavigationService>().navigateToNamed(
              Routes.cart,
            );
          },
          icon: UpIcon(
              icon: Icons.shopping_bag,
              style: UpStyle(
                  iconColor: UpThemes.getContrastColor(
                      UpConfig.of(context).theme.primaryColor))),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
