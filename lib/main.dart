import 'package:flutter/material.dart';

import 'package:real_estate/theme/color.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:real_estate/pages/explore.dart';
import 'package:real_estate/pages/agents.dart';
import 'package:real_estate/pages/settings.dart';
import 'package:real_estate/pages/home.dart';
import 'package:real_estate/pages/login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    theme: ThemeData(
      fontFamily: 'Arial',
      //primarySwatch: Color(0xff0f385a),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: AppColor.primary),
        ),
      ),
    ),
    routes: {
      '/': (context) => const LoginPage(),
      '/home': (context) => const HomePage(),
      '/listings': (context) => const ExplorePage(
            listingType: "all",
          ),
      '/agents': (context) => const AgentsPage(),
      '/cart': (context) => const HomePage(),
      '/setting': (context) => const SettingsPage(),
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: currentIndex,
          showElevation: true,
          itemCornerRadius: 8,
          curve: Curves.easeInBack,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            controller.animateToPage(index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInSine);
          }),
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              activeColor: AppColor.primary,
              inactiveColor: AppColor.inActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.menu),
              title: const Text('Listing'),
              activeColor: AppColor.primary,
              inactiveColor: AppColor.inActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text(
                'Agents',
              ),
              activeColor: AppColor.primary,
              inactiveColor: AppColor.inActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.heart_broken_outlined),
              title: const Text('Favourites'),
              activeColor: AppColor.primary,
              inactiveColor: AppColor.inActiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.settings_outlined),
              title: const Text('Setting'),
              activeColor: AppColor.primary,
              inactiveColor: AppColor.inActiveColor,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: AppColor.bottomBarColor,
        body: PageView(
            controller: controller,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: const [
              HomePage(),
              ExplorePage(listingType: "all"),
              AgentsPage(),
              HomePage(),
              SettingsPage()
            ]));
  }
}
