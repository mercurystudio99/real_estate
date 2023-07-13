import 'package:flutter/material.dart';
import 'package:real_estate/pages/dashboard.dart';
import 'package:real_estate/theme/color.dart';

class OTPPage extends StatefulWidget {
  const OTPPage({Key? key}) : super(key: key);

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final FocusNode _focusOne = FocusNode();
  final FocusNode _focusTwo = FocusNode();
  final FocusNode _focusThree = FocusNode();
  final FocusNode _focusFour = FocusNode();

  // This is the entered code
  // It will be displayed in a Text widget
  String _otp = '';

  void _getOTPcode() {
    setState(() {
      _otp =
          _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusOne.dispose();
    _focusTwo.dispose();
    _focusThree.dispose();
    _focusFour.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 30,
                height: 30,
                color: Colors.grey.shade300,
                child: Center(
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.grey, fontSize: 20),
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
                color: AppColor.primary,
                child: Center(
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: const Text(
                  'We sent OTP code to verify your number',
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold),
                ))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OtpInput(_fieldOne, _focusOne, true), // auto focus
              OtpInput(_fieldTwo, _focusTwo, false),
              OtpInput(_fieldThree, _focusThree, false),
              OtpInput(_fieldFour, _focusFour, false)
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
          child: SizedBox(
              height: 50, //height of button
              width: MediaQuery.of(context).size.width, //width of button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    elevation: 10, //elevation of button
                    shape: RoundedRectangleBorder(
                        //to set border radius to button
                        borderRadius: BorderRadius.circular(100)),
                    shadowColor: Colors.black.withOpacity(0.4),
                    padding:
                        const EdgeInsets.all(5) //content padding inside button
                    ),
                onPressed: () {
                  _getOTPcode();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                  );
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
    ));
  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final bool autoFocus;

  const OtpInput(this.controller, this.focus, this.autoFocus, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Material(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: TextField(
          focusNode: focus,
          autofocus: autoFocus,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: 1,
          cursorColor: Theme.of(context).primaryColor,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  borderSide: BorderSide(color: Colors.white)),
              counterText: '',
              hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}
