import 'package:flutter/material.dart';
import 'package:aradhana/utils/util.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Image.asset('${Util.imagePath}logo.jpg'),
          ),
        ],
      ),
    );
  }
}
