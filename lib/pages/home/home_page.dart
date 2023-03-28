// import 'package:dynamic_themes/dynamic_themes.dart';
// import 'package:flutter/material.dart';
// import 'package:shop/widgets/user_info.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   toggleTheme(BuildContext context, int themeId) {
//     DynamicTheme.of(context)!.setTheme(themeId);
//     //AppThemes.LightRed);

// //    Brightness currentbrightness = DynamicTheme.of(context).brightness;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home Page'),
//       ),
//       body: Column(
//         children: const [
//           UserInfoWidget(),
//           // Row(
//           //   children: [
//           //     FloatingActionButton(
//           //       heroTag: "ActionSetLightBlueTheme",
//           //       onPressed: () {
//           //         toggleTheme(context, AppThemes.lightBlue);
//           //       },
//           //       child: const Icon(Icons.add),
//           //     ),
//           //     FloatingActionButton(
//           //       heroTag: "ActionSetLightRedTheme",
//           //       onPressed: () {
//           //         toggleTheme(context, AppThemes.lightRed);
//           //       },
//           //       child: const Icon(Icons.add),
//           //     ),
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
// }
