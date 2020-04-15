import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:zion/model/app.dart';
import 'package:zion/service/user_profile_service.dart';
import 'package:zion/views/screens/chat/chat_page.dart';
import 'package:zion/views/screens/home/home_page.dart';
import 'package:zion/views/screens/search/search_page.dart';
import 'package:zion/views/screens/settings/settings_page.dart';

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
  // active color of the bottom app bar
  Color activeColor;
  //Inactive color of the bottom app bar
  Color inActiveColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    UserProfileService.setOnlineStatus();
    // controllers for the bottom_nav_bar
    _controller = PersistentTabController(initialIndex: initialIndex);

    // executes the function when the notification tray is click
    // for app in background or foreground
    OneSignal.shared.setNotificationOpenedHandler((handler) {
      String link = handler.notification.payload.additionalData["screen"];
      if (link == "/chatpage") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatPage()));
        });
      }
    });

    // executes the function when the app is open
    OneSignal.shared.setNotificationReceivedHandler((handler) {
      String link = handler.payload.additionalData["screen"];
      if (link == "/chatpage") {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatPage()));
        });
      }
    });
    // initialize
    Provider.of<User>(context, listen: false).getUser();
  }

// list of bottom navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: activeColor,
        inactiveColor: inActiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: ("Search"),
        activeColor: activeColor,
        inactiveColor: inActiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.message),
        title: ("Chats"),
        activeColor: activeColor,
        inactiveColor: inActiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColor: activeColor,
        inactiveColor: inActiveColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // assign primary color to the activeColor variable
    final appContext = Theme.of(context);
    activeColor = appContext.bottomAppBarTheme.color;

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
      showElevation: true,
      navBarCurve: NavBarCurve.none,
      backgroundColor: appContext.bottomAppBarColor,
      iconSize: 26.0,

      // Choose the nav bar style with this property
      navBarStyle: NavBarStyle.style6,
      onItemSelected: (index) {
        print(index);
      },
    );
  }
}
