import 'package:flutter/material.dart';
import 'package:real_estate/pages/explore.dart';
import 'package:real_estate/pages/agents.dart';
import 'package:real_estate/pages/settings.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/widgets/bottombar_item.dart';

import 'home.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int currentIndex = 0;
  final controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  int _activeTab = 0;
  final List _barItems = [
    {
      "name": "Home",
      "icon": Icons.home_outlined,
      "active_icon": Icons.home_rounded,
      "page": HomePage(),
    },
    {
      "icon": Icons.dehaze_outlined,
      "active_icon": Icons.density_small_sharp,
      "page": ExplorePage(
        listingType: "all",
        independentLayout: false,
      ),
    },
    {
      "icon": Icons.person,
      "active_icon": Icons.person_outlined,
      "page": AgentsPage(),
    },
    {
      "icon": Icons.forum_outlined,
      "active_icon": Icons.forum_rounded,
      "page": HomePage(),
    },
    {
      "icon": Icons.settings_outlined,
      "active_icon": Icons.settings_rounded,
      "page": SettingsPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: _buildPage(),
      floatingActionButton: _buildBottomBar(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _activeTab,
      children: List.generate(
        _barItems.length,
        (index) => _barItems[index]["page"],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 55,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.bottomBarColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          _barItems.length,
          (index) => BottomBarItem(
            _activeTab == index
                ? _barItems[index]["active_icon"]
                : _barItems[index]["icon"],
            isActive: _activeTab == index,
            activeColor: AppColor.primary,
            onTap: () {
              setState(() {
                _activeTab = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
