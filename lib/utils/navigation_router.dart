import 'package:flutter/material.dart';

class NavigationRouter {
  static void back(BuildContext context) {
    Navigator.pop(context);
  }

  static void switchToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/LoginScreen");
  }

  static void switchToOTP(BuildContext context) {
    Navigator.pushNamed(context, "/OTPScreen");
  }
}
