import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/globals.dart' as global;

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool _fnamestate = false;
  bool _lnamestate = false;
  bool _emailstate = false;
  bool _phonestate = false;
  bool _addressstate = false;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Future<void> _changePhone() async {
  //   final SharedPreferences prefs = await _prefs;
  //   List<String>? memberTypes = prefs.getStringList('membertypes');
  //   if (memberTypes == null) {
  //     memberTypes = [];
  //   }
  //   List<String> result = [];
  //   memberTypes.forEach((element) {
  //     List<String> info = element.split('_');
  //     if (info[0] == global.phone) {
  //       result.add(_phoneController.text.trim() + '_' + info[1]);
  //     } else {
  //       result.add(element);
  //     }
  //   });
  //   prefs.setStringList('membertypes', result).then((bool success) {
  //     global.phone = _phoneController.text.trim();
  //   });
  // }

  Future<void> _updateProfile() async {
    Map<String, String> formData = {
      "first_name": _fnameController.text.trim(),
      "last_name": _lnameController.text.trim(),
      "email": _emailController.text.trim(),
      "location": _addressController.text.trim(),
      "phone": _phoneController.text.trim(),
    };

    final response = await http.post(
        Uri.parse('https://properties-api.myspacetech.in/ver1/updateuser/'),
        body: formData);
  }

  String _validate() {
    if (_fnameController.text.trim().isEmpty) {
      return "Please enter your first name";
    }
    if (_lnameController.text.trim().isEmpty) {
      return "Please enter your last name";
    }
    if (_addressController.text.trim().isEmpty) {
      return "Please enter your location";
    }

    if (_phoneController.text.trim().isEmpty) {
      return "Please enter your phone number";
    }
    RegExp regExp = new RegExp(r'^(?:[+0][1-9])?[0-9]{9,10}$');
    regExp.hasMatch(_phoneController.text.trim());
    if (!regExp.hasMatch(_phoneController.text.trim())) {
      return "Please enter a valid phone number";
    }
    if (_emailController.text.trim().isEmpty) {
      return "Please enter your email";
    }
    bool emailExist = false;
    global.users.forEach((element) {
      if (element['email'] == _emailController.text.trim()) {
        emailExist = true;
      }
    });
    if (emailExist) {
      return "Please enter another email";
    }
    return 'success';
  }

  @override
  void initState() {
    if (mounted == true) {
      super.initState();
      _fnameController.text = global.firstName;
      _lnameController.text = global.lastName;
      _emailController.text = global.email;
      _phoneController.text = global.phone;
      _addressController.text = global.location;
      if (global.firstName.length > 0) _fnamestate = true;
      if (global.lastName.length > 0) _lnamestate = true;
      if (global.email.length > 0) _emailstate = true;
      if (global.phone.length > 0) _phonestate = true;
      if (global.location.length > 0) _addressstate = true;
      configLoading();
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    _fnameController.dispose();
    _lnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 1000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 50.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.red
      ..maskColor = Colors.white.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  File? _imageFile;
  String picture = "";

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        )),
                    Text(
                      'EDIT PROFILE',
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    IconButton(
                        onPressed: () {
                          if (_validate() != 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_validate())));
                            return;
                          }
                          global.firstName = _fnameController.text.trim();
                          global.lastName = _lnameController.text.trim();
                          global.location = _addressController.text.trim();
                          global.email = _emailController.text.trim();
                          global.phone = _phoneController.text.trim();
                          // _changePhone();
                          _updateProfile();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Successfully updated!')));
                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.black,
                        ))
                  ]),
            ),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: Center(
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: _imageFile == null
                              ? ((picture == "")
                                  ? AssetImage("assets/images/aradhana.png")
                                      as ImageProvider<Object>
                                  : NetworkImage(
                                      "https://dev.signd.com/wp-content/uploads/icons-profile/" +
                                          picture) as ImageProvider<Object>)
                              : FileImage(File(_imageFile!.path)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5.0,
                      right: 15.0,
                      child: InkWell(
                        onTap: () {
                          _getImage(ImageSource.camera);
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              border: Border.all(color: Colors.grey, width: 1)),
                          padding: const EdgeInsets.all(3),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(height: 20),
            ListTile(
              title: Text('PUBLIC INFORMATION'),
            ),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Set the desired border color
                    width: 1.0, // Set the desired border width
                  ),
                ),
                child: TextField(
                  controller: _fnameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    suffixIcon: _fnamestate
                        ? Icon(
                            Icons.check,
                            color: AppColor.green,
                          )
                        : Icon(
                            Icons.close,
                            color: AppColor.red,
                          ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'First name',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 14.0, top: 14.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _fnamestate = false;
                    } else {
                      _fnamestate = true;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Set the desired border color
                    width: 1.0, // Set the desired border width
                  ),
                ),
                child: TextField(
                  controller: _lnameController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    suffixIcon: _lnamestate
                        ? Icon(
                            Icons.check,
                            color: AppColor.green,
                          )
                        : Icon(
                            Icons.close,
                            color: AppColor.red,
                          ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Last name',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 14.0, top: 14.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _lnamestate = false;
                    } else {
                      _lnamestate = true;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Set the desired border color
                    width: 1.0, // Set the desired border width
                  ),
                ),
                child: TextField(
                  controller: _addressController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    suffixIcon: _addressstate
                        ? Icon(
                            Icons.check,
                            color: AppColor.green,
                          )
                        : Icon(
                            Icons.close,
                            color: AppColor.red,
                          ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Location',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 14.0, top: 14.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _addressstate = false;
                    } else {
                      _addressstate = true;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Set the desired border color
                    width: 1.0, // Set the desired border width
                  ),
                ),
                child: TextField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    suffixIcon: _phonestate
                        ? Icon(
                            Icons.check,
                            color: AppColor.green,
                          )
                        : Icon(
                            Icons.close,
                            color: AppColor.red,
                          ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Phone',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 14.0, top: 14.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _phonestate = false;
                    } else {
                      _phonestate = true;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.grey, // Set the desired border color
                    width: 1.0, // Set the desired border width
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    suffixIcon: _emailstate
                        ? Icon(
                            Icons.check,
                            color: AppColor.green,
                          )
                        : Icon(
                            Icons.close,
                            color: AppColor.red,
                          ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 14.0, top: 14.0),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _emailstate = false;
                    } else {
                      _emailstate = true;
                    }
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
