import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate/theme/color.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);

  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String _memberType = '';

  Future<void> _setMemberType() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('membertype', _memberType).then((bool success) {
      return true;
    });
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      String? memberType = prefs.getString('membertype');
      if (memberType == null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      const SizedBox(height: 40),
      // Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 12),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       InkWell(
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //         child: Container(
      //           height: 50,
      //           width: 50,
      //           child: Icon(
      //             Icons.arrow_back_ios_new,
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      const SizedBox(height: 100),
      Center(
        child: Text(
          'Choose',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      const SizedBox(height: 40),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      _memberType = 'customer';
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 4, color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                (_memberType == 'customer')
                                    ? Colors.transparent
                                    : Colors.black,
                                BlendMode.color),
                            child: Image.asset(
                              'assets/images/customer.png',
                              fit: BoxFit.cover,
                            ))),
                  )),
              const SizedBox(height: 15),
              const Text(
                'Customer',
                style: TextStyle(fontSize: 20),
              )
            ]),
            Column(children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      _memberType = 'vendor';
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 4, color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                (_memberType == 'vendor')
                                    ? Colors.transparent
                                    : Colors.black,
                                BlendMode.color),
                            child: Image.asset(
                              'assets/images/vendor.png',
                              fit: BoxFit.cover,
                            ))),
                  )),
              const SizedBox(height: 15),
              const Text(
                'Vendor ',
                style: TextStyle(fontSize: 20),
              )
            ]),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      _memberType = 'developer';
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 4, color: Colors.red),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                (_memberType == 'developer')
                                    ? Colors.transparent
                                    : Colors.black,
                                BlendMode.color),
                            child: Image.asset(
                              'assets/images/developer.png',
                              fit: BoxFit.cover,
                            ))),
                  )),
              const SizedBox(height: 15),
              const Text(
                'Developer',
                style: TextStyle(fontSize: 20),
              )
            ]),
          ],
        ),
      ),
      if (_memberType.length > 0)
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
                  Navigator.pop(context);
                  _setMemberType();
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              )),
        )
    ])));
  }
}
