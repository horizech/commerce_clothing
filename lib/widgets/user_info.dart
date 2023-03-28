import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({Key? key}) : super(key: key);

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  int currentUserId = 0;
  String currentUsername = "";
  String currentUserEmail = "";
  String currentUserFullname = "";
  String currentUserToken = "";
  int currentUserRoleId = 0;
  String currentUserRoleName = "";

  Future<void> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      currentUserId = prefs.getInt("CurrentUserId") ?? 0;
      currentUsername = prefs.getString("CurrentUsername") ?? "";
      currentUserEmail = prefs.getString("CurrentUserEmail") ?? "";
      currentUserFullname = prefs.getString("CurrentUserFullname") ?? "";
      currentUserToken = prefs.getString("CurrentUserToken") ?? "";
      currentUserRoleId = prefs.getInt("CurrentUserRoleId") ?? 0;
      currentUserRoleName = prefs.getString("CurrentUserRoleName") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      child: Container(
        margin: const EdgeInsets.all(32),
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.green, spreadRadius: 3),
          ],
        ),
        child: Column(
          children: [
            Text("Welcome $currentUserFullname!"),
            Text("Id: $currentUserId"),
            Text("Username: $currentUsername"),
            Text("Email: $currentUserEmail"),
            Text("Full name:  $currentUserFullname"),
            SelectableText("Token: $currentUserToken"),
            Text("Role Id: $currentUserRoleId"),
            Text("Role name: $currentUserRoleName"),
          ],
        ),
      ),
    );
  }
}
