import 'package:flutter/material.dart';
import 'package:flutter_up/widgets/up_app_bar.dart';
import 'package:flutter_up/widgets/up_scaffold.dart';
import 'package:flutter_up/widgets/up_text.dart';
import 'package:shop/is_user_admin.dart';
import 'package:shop/widgets/drawers/nav_drawer.dart';
import 'package:shop/widgets/unauthorized_widget.dart';

class Admin extends StatelessWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UpScaffold(
      appBar: const UpAppBar(),
      drawer: const NavDrawer(),
      body: isUserAdmin() ? const UpText("Admin") : const UnAuthorizedWidget(),
    );
  }
}
