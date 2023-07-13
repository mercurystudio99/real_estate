import 'package:flutter/material.dart';

import 'package:real_estate/theme/color.dart';
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
      // primarySwatch: Color(0xFF10174B),
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
