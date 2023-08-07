import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/pages/explore.dart';
import 'package:real_estate/pages/agents.dart';
import 'package:real_estate/pages/settings.dart';
import 'package:real_estate/pages/home.dart';
import 'package:real_estate/pages/login.dart';
import 'package:real_estate/pages/dashboard.dart';
import 'package:real_estate/utils/globals.dart' as global;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? isLogged = prefs.getString('phone');
  if (isLogged == null) isLogged = '';
  global.phone = isLogged;

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
      '/': (context) =>
          (isLogged!.length > 0) ? const Dashboard() : const LoginPage(),
      '/home': (context) => const HomePage(),
      '/listings': (context) => const ExplorePage(
            listingType: "all",
            independentLayout: false,
          ),
      '/agents': (context) => const AgentsPage(),
      '/cart': (context) => const HomePage(),
      '/setting': (context) => const SettingsPage(),
    },
  ));
}
