import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:zion/user_inteface/screens/chat/chat_page.dart';
import 'package:zion/user_inteface/screens/home/home_page.dart';
import 'package:zion/user_inteface/screens/search/search_page.dart';
import 'package:zion/user_inteface/screens/settings/settings_page.dart';
import 'package:zion/user_inteface/utils/color_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PersistentTabController _controller;
  // initial index for the bottom nav bar
  // the default is 0
  int initialIndex = 0;

  @override
  void initState() {
    super.initState();
    // controllers for the bottom_nav_bar
    _controller = PersistentTabController(initialIndex: initialIndex);
  }

// list of bottom navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: ColorUtils.primaryColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: ("Search"),
        activeColor: ColorUtils.primaryColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.message),
        title: ("Chats"),
        activeColor: ColorUtils.primaryColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColor: ColorUtils.primaryColor,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      items: _navBarsItems(),
      // displays the current screen based on the index
      // selected in the bottom navigation bar
      screens: <Widget>[
        HomePage(),
        SearchPage(),
        ChatPage(),
        SettingsPage(),
      ],
      showElevation: false,
      navBarCurve: NavBarCurve.none,
      backgroundColor: const Color(0xFFEBEEF1),
      iconSize: 26.0,
      navBarStyle:
          NavBarStyle.style6, // Choose the nav bar style with this property
      onItemSelected: (index) {
        print(index);
      },
    );
  }
}
