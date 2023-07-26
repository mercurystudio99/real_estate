import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate/pages/otp.dart';
import 'package:real_estate/pages/choose.dart';
import 'package:real_estate/theme/color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();

  // Obtain shared preferences.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String? _validatePhone(String value) {
    if (value.isEmpty) {
      return "\u26A0 Please enter your phone number";
    }
    RegExp regExp = new RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$');
    regExp.hasMatch(value);
    if (!regExp.hasMatch(value)) {
      return "\u26A0 Please enter a valid phone number";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      String? memberType = prefs.getString('membertype');
      if (memberType == null) {
        Timer(
            const Duration(seconds: 1),
            () => Navigator.restorablePush<void>(
                context, _fullscreenDialogRoute));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 30,
                  height: 30,
                  color: AppColor.primary,
                  child: Center(
                    child: const Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 30,
                  height: 30,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: const Text(
                      '2',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A",
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "RADHANA",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: const Text(
                    'Enter mobile number and login',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold),
                  ))),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 1),
                          ],
                        ),
                      ),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              borderSide: BorderSide(color: Colors.white)),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              borderSide: BorderSide(color: Colors.red)),
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          return _validatePhone(value!);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                  child: SizedBox(
                      height: 50, //height of button
                      width:
                          MediaQuery.of(context).size.width, //width of button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            elevation: 10, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(100)),
                            shadowColor: Colors.black.withOpacity(0.4),
                            padding: const EdgeInsets.all(
                                5) //content padding inside button
                            ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _prefs.then((SharedPreferences prefs) {
                              String? memberType =
                                  prefs.getString('membertype');
                              if (memberType == null) {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Choose a member type')),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OTPPage()),
                                );
                              }
                            });
                          }
                        },
                        child: const Text(
                          'NEXT',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  static Route<void> _fullscreenDialogRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return MaterialPageRoute<void>(
      builder: (context) => ChoosePage(),
      fullscreenDialog: true,
    );
  }
}
