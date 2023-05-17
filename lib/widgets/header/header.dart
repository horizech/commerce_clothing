import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/collection_tree_item.dart';
import 'package:shop/widgets/header/main_menu.dart';
import 'package:shop/widgets/store/store_cubit.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
//  double width= MediaQuery.of(context).size.width,
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  OverlayEntry? overlayEntry2;
  bool showOverlay = false;
  int index = 0;

  List<Widget> widgets = [];

  void initializeOverLayWidgets(
      BuildContext context, List<CollectionTreeItem>? children) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    widgets = [
      Container(height: 10, width: width, color: Colors.transparent),
      Container(height: 10, width: width, color: Colors.transparent),
      Align(
        alignment: Alignment.topLeft,
        child: Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            height: height,
            width: width,
            color: Colors.green,
            child: Column(
                children: children != null
                    ? children
                        .map((e) => Column(
                              children: [
                                Text(e.name),
                                _getSubCategories(e.children)
                              ],
                            ))
                        .toList()
                    : [const Text("")])),
      )
    ];
  }

  Widget _getSubCategories(List<CollectionTreeItem>? children) {
    if (children != null) {
      return Column(children: children.map((e) => Text(e.name)).toList());
    }
    return const Text("");
  }

  final layerLink = LayerLink();
  final textButtonFocusNode = FocusNode();
  final textButtonFocusNode1 = FocusNode();

  void _showOverlay(BuildContext context, int index) async {
    overlayState = Overlay.of(context);

    overlayEntry = OverlayEntry(
        maintainState: true,
        builder: (context) {
          return widgets[index];
          // return Positioned(
          //     top: 0.0,
          //     left: 0.0,
          //     // left: index == 0
          //     //     ? MediaQuery.of(context).size.width * 0.43
          //     //     : MediaQuery.of(context).size.width * 0.5,
          //     // top: MediaQuery.of(context).size.height * 0.09,
          //     child: TextButton(
          //       onPressed: () {},
          //       onHover: (val) {
          //         if (val && showOverlay) {
          //           if (index == 0) {
          //             textButtonFocusNode.requestFocus();
          //           } else if (index == 1) {
          //             textButtonFocusNode1.requestFocus();
          //           }
          //         } else {
          //           if (index == 0) {
          //             textButtonFocusNode.unfocus();
          //           } else if (index == 1) {
          //             textButtonFocusNode1.unfocus();
          //           }
          //         }
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.all(0.0),
          //         child: widgets[index],
          //       ),
          //     ));
        });
    overlayEntry2 = OverlayEntry(
        maintainState: true,
        builder: (context) {
          return Positioned(
            left: index == 0
                ? MediaQuery.of(context).size.width * 0.43
                : MediaQuery.of(context).size.width * 0.5,
            top: MediaQuery.of(context).size.height * 0.13,
            child: TextButton(
              onPressed: () {},
              onHover: (val) {
                if (val && showOverlay) {
                  if (index == 0) {
                    textButtonFocusNode.requestFocus();
                  } else if (index == 1) {
                    textButtonFocusNode1.requestFocus();
                  }
                } else {
                  if (index == 0) {
                    textButtonFocusNode.unfocus();
                  } else if (index == 1) {
                    textButtonFocusNode1.unfocus();
                  }
                }
              },
              child: widgets[index + 2],
            ),
          );
        });

    // overlayState!.insert(overlayEntry!);
    overlayState!.insertAll([overlayEntry!, overlayEntry2!]);
  }

  void removeOverlay() {
    overlayEntry!.remove();
    overlayEntry2!.remove();
  }

  @override
  void initState() {
    super.initState();
    textButtonFocusNode.addListener(() {
      if (textButtonFocusNode.hasFocus) {
        _showOverlay(context, 0);
      } else {
        removeOverlay();
      }
    });
    textButtonFocusNode1.addListener(() {
      if (textButtonFocusNode1.hasFocus) {
        _showOverlay(context, 1);
      } else {
        removeOverlay();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 600
        ? BlocConsumer<StoreCubit, StoreState>(
            listener: (context, state) {},
            builder: (context, state) {
              return const MainMenu();
            })
        : const Text("");
  }
}


// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// // class MyHomePage extends StatefulWidget {
// //   const MyHomePage({Key? key, required this.title}) : super(key: key);

// //   final String title;

// //   @override
// //   State<MyHomePage> createState() => _MyHomePageState();
// // }

// // class _MyHomePageState extends State<MyHomePage> {
// //   OverlayState? overlayState;
// //   OverlayEntry? overlayEntry;
// //   OverlayEntry? overlayEntry2;
// //   bool showOverlay = false;
// //   int index = 0;
// //   List<Widget> widgets = [
// //     Container(height: 40, width: 60, color: Colors.transparent),
// //     Container(height: 40, width: 60, color: Colors.transparent),
// //     Container(
// //       height: 400,
// //       width: 100,
// //       color: Colors.green,
// //       child: TextButton(
// //         child: const Text('Click Me'),
// //         onPressed: () {
// //           print('Clicked');
// //         },
// //       ),
// //     ),
// //     Container(
// //       height: 300,
// //       width: 300,
// //       color: Colors.black,
// //       child: TextButton(
// //         child: const Text('Click Me'),
// //         onPressed: () {
// //           print('Clicked');
// //         },
// //       ),
// //     ),
// //   ];
// //   final layerLink = LayerLink();
// //   final textButtonFocusNode = FocusNode();
// //   final textButtonFocusNode1 = FocusNode();

// //   void _showOverlay(BuildContext context, int index) async {
// //     overlayState = Overlay.of(context)!;

// //     overlayEntry = OverlayEntry(
// //         maintainState: true,
// //         builder: (context) {
// //           return Positioned(
// //             left: index == 0
// //                 ? MediaQuery.of(context).size.width * 0.43
// //                 : MediaQuery.of(context).size.width * 0.5,
// //             top: MediaQuery.of(context).size.height * 0.09,
// //             child: TextButton(
// //               onPressed: () {},
// //               onHover: (val) {
// //                 if (val && showOverlay) {
// //                   if (index == 0) {
// //                     textButtonFocusNode.requestFocus();
// //                   } else if (index == 1) {
// //                     textButtonFocusNode1.requestFocus();
// //                   }
// //                 } else {
// //                   if (index == 0) {
// //                     textButtonFocusNode.unfocus();
// //                   } else if (index == 1) {
// //                     textButtonFocusNode1.unfocus();
// //                   }
// //                 }
// //               },
// //               child: widgets[index],
// //             ),
// //           );
// //         });
// //     overlayEntry2 = OverlayEntry(
// //         maintainState: true,
// //         builder: (context) {
// //           return Positioned(
// //             left: index == 0
// //                 ? MediaQuery.of(context).size.width * 0.43
// //                 : MediaQuery.of(context).size.width * 0.5,
// //             top: MediaQuery.of(context).size.height * 0.13,
// //             child: TextButton(
// //               onPressed: () {},
// //               onHover: (val) {
// //                 if (val && showOverlay) {
// //                   if (index == 0) {
// //                     textButtonFocusNode.requestFocus();
// //                   } else if (index == 1) {
// //                     textButtonFocusNode1.requestFocus();
// //                   }
// //                 } else {
// //                   if (index == 0) {
// //                     textButtonFocusNode.unfocus();
// //                   } else if (index == 1) {
// //                     textButtonFocusNode1.unfocus();
// //                   }
// //                 }
// //               },
// //               child: widgets[index + 2],
// //             ),
// //           );
// //         });

// //     // overlayState!.insert(overlayEntry!);
// //     overlayState!.insertAll([overlayEntry!, overlayEntry2!]);
// //   }

// //   void removeOverlay() {
// //     overlayEntry!.remove();
// //     overlayEntry2!.remove();
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     textButtonFocusNode.addListener(() {
// //       if (textButtonFocusNode.hasFocus) {
// //         _showOverlay(context, 0);
// //       } else {
// //         removeOverlay();
// //       }
// //     });
// //     textButtonFocusNode1.addListener(() {
// //       if (textButtonFocusNode1.hasFocus) {
// //         _showOverlay(context, 1);
// //       } else {
// //         removeOverlay();
// //       }
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.title),
// //       ),
// //       body: SizedBox(
// //         height: 100,
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextButton(
// //               focusNode: textButtonFocusNode,
// //               onHover: (val) {
// //                 if (val) {
// //                   textButtonFocusNode.requestFocus();
// //                   showOverlay = true;
// //                 }
// //               },
// //               onPressed: () {},
// //               child: const Text('Hover'),
// //             ),
// //             TextButton(
// //               focusNode: textButtonFocusNode1,
// //               onHover: (val) {
// //                 if (val) {
// //                   textButtonFocusNode1.requestFocus();
// //                   showOverlay = true;
// //                 }
// //               },
// //               onPressed: () {},
// //               child: const Text('Hover'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
