import 'package:flutter/material.dart';

class OverlayTest extends StatefulWidget {
  const OverlayTest({Key? key}) : super(key: key);
  @override
  State<OverlayTest> createState() => _MainMenuState();
}

class _MainMenuState extends State<OverlayTest> {
  OverlayState? overlayState;
  OverlayEntry? overlayEntry;
  OverlayEntry? overlayEntry2;
  bool showOverlay = false;
  int index = 0;

  getWidgets(BuildContext context) => [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 512,
          color: Colors.purple,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 512,
          color: Colors.pink,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          color: Colors.green,
          child: TextButton(
            child: const Text('Click Me'),
            onPressed: () {
              debugPrint('Clicked');
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          color: Colors.black,
          child: TextButton(
            child: const Text('Click Me'),
            onPressed: () {
              debugPrint('Clicked');
            },
          ),
        ),
      ];
  final layerLink = LayerLink();
  final textButtonFocusNode = FocusNode();
  final textButtonFocusNode1 = FocusNode();

  void _showOverlay(BuildContext context, int index) async {
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
              // onHover: (val) {
              //   if (val && showOverlay) {
              //     if (index == 0) {
              //       textButtonFocusNode.requestFocus();
              //     } else if (index == 1) {
              //       textButtonFocusNode1.requestFocus();
              //     }
              //   } else {
              //     if (index == 0) {
              //       textButtonFocusNode.unfocus();
              //     } else if (index == 1) {
              //       textButtonFocusNode1.unfocus();
              //     }
              //   }
              // },
              child: getWidgets(context)[index],
            ),
          );
        });
    overlayEntry2 = OverlayEntry(
        maintainState: true,
        builder: (context) {
          return Positioned(
            left: MediaQuery.of(context).size.width * 0.1,
            // index == 0
            //     ? MediaQuery.of(context).size.width * 0.43
            //     : MediaQuery.of(context).size.width * 0.5,
            top: 112,
            // top: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.8,
            height: 512,
            child: TextButton(
              onPressed: () {},
              // onHover: (val) {
              //   if (val && showOverlay) {
              //     if (index == 0) {
              //       textButtonFocusNode.requestFocus();
              //     } else if (index == 1) {
              //       textButtonFocusNode1.requestFocus();
              //     }
              //   } else {
              //     if (index == 0) {
              //       textButtonFocusNode.unfocus();
              //     } else if (index == 1) {
              //       textButtonFocusNode1.unfocus();
              //     }
              //   }
              // },
              child: getWidgets(context)[index + 2],
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
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            focusNode: textButtonFocusNode,
            onHover: (val) {
              if (val) {
                textButtonFocusNode.requestFocus();
                showOverlay = true;
              }
            },
            onPressed: () {},
            child: const Text('Hover'),
          ),
          TextButton(
            focusNode: textButtonFocusNode1,
            onHover: (val) {
              if (val) {
                textButtonFocusNode1.requestFocus();
                showOverlay = true;
              }
            },
            onPressed: () {},
            child: const Text('Hover'),
          ),
        ],
      ),
    );
  }
}
