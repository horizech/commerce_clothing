// import 'package:apiraiser/apiraiser.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginSessionWidget extends StatefulWidget {
//   const LoginSessionWidget({Key? key}) : super(key: key);

//   @override
//   State<LoginSessionWidget> createState() => _LoginSessionWidgetState();
// }

// class _LoginSessionWidgetState extends State<LoginSessionWidget> {
//   /*
//   User user;
//   Future<void> getSharedPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       user = CurrentUser(
//           prefs.getInt("CurrentUserId") ?? 0,
//           prefs.getString("CurrentUsername") ?? "",
//           prefs.getString("CurrentUserEmail") ?? "",
//           prefs.getString("CurrentUserFullname") ?? "",
//           prefs.getString("CurrentUserToken") ?? "",
//           prefs.getInt("CurrentUserRoleId") ?? 0,
//           prefs.getString("CurrentUserRoleName") ?? "");
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     getSharedPrefs();
//   }
//   */

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _loadSession();
//   }

//   _loadSession() async {
//     final ApiraiserAuthenticationCubit authenticationCubit =
//         BlocProvider.of<ApiraiserAuthenticationCubit>(context);
//     User? user = await authenticationCubit.loadSession();
//     if (user != null) {
//       // ServiceManager<UpNavigationService>()
//       //     .navigateToNamed(SimpleHomePage.routeName, replace: true);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ApiraiserAuthenticationCubit,
//         ApiraiserAuthenticationState>(
//       listener: (context, state) {},
//       builder: (context, state) => Center(
//         child: Visibility(
//           visible: state.isLoading,
//           child: const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     );
//   }
// }
