import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:thoughts/screens/imagemaker.dart';
import 'package:thoughts/screens/menuScreen.dart';
import 'package:thoughts/screens/thoughts.dart';

class FlutterZoomDrawerDemo extends StatefulWidget {
  @override
  _FlutterZoomDrawerDemoState createState() => _FlutterZoomDrawerDemoState();
}

class _FlutterZoomDrawerDemoState extends State<FlutterZoomDrawerDemo> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();
  List<ScreenHiddenDrawer> pages = [];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "thoughtss",
              baseStyle: TextStyle(color: Colors.white),
              selectedStyle: TextStyle(color: Colors.white)),
          Thoughts()),
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Settings",
              baseStyle: TextStyle(color: Colors.white),
              selectedStyle: TextStyle(color: Colors.white)),
          MenuScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        controller: _drawerController,
        // overlayBlend: BlendMode.color,
        clipMainScreen: true,
        menuBackgroundColor: Color.fromARGB(255, 31, 31, 31),
        menuScreenTapClose: true,
        // mainScreenOverlayColor: Color.fromARGB(255, 0, 0, 0),
        angle: 0.0,
        menuScreen: MenuScreen(),
        mainScreen: Thoughts());
  }
}
