// tab_bar.dart
import 'package:flutter/cupertino.dart';

class CustomTabBar extends CupertinoTabBar {
  const CustomTabBar({
    super.key,
    required super.currentIndex,
    required Function(int) super.onTap,
  }) : super(
         iconSize: 30.0,
         height: 60.0,
         //backgroundColor: const Color.fromARGB(255, 255, 255, 255),
         items: const <BottomNavigationBarItem>[
           BottomNavigationBarItem(
             icon: Icon(CupertinoIcons.home),
             label: 'Home',
           ),
           BottomNavigationBarItem(
             icon: Icon(CupertinoIcons.settings),
             label: 'Setting',
           ),
         ],
       );
}
