import 'package:flutter/material.dart';
import 'package:restaurant_flutter/page/restaurant_detail_page.dart';
import 'package:restaurant_flutter/page/restaurant_page.dart';
import 'package:restaurant_flutter/page/settings_page.dart';
import 'package:restaurant_flutter/utils/service/notification_helper.dart';

import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();
  final List<Widget> _widgetList = [
    const RestaurantPage(),
    const FavoritePage(),
    const SettingsPage()
  ];

  final List<BottomNavigationBarItem> _bottomNavbarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorite',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onBottomNavTapped(int i) {
    setState(() {
      _bottomNavIndex = i;
    });
  }

  @override
  void initState() {
    _notificationHelper.configureNotificationSubject(RestaurantDetailPage.routeName);
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetList[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavbarItems,
        currentIndex: _bottomNavIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
