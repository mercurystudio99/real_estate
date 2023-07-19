import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:real_estate/theme/color.dart';

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

  @override
  void initState() {
    if (mounted == true) {
      super.initState();
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
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    ),
                    Text(
                      'EDIT PROFILE',
                      style: TextStyle(color: Colors.grey, fontSize: 22),
                    ),
                    Icon(
                      Icons.check,
                      color: Colors.black,
                    )
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
                    suffixIcon: Icon(
                      Icons.check,
                      color: AppColor.green,
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
                    suffixIcon: Icon(
                      Icons.check,
                      color: AppColor.green,
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
                    suffixIcon: Icon(
                      Icons.check,
                      color: AppColor.green,
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
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.check,
                      color: AppColor.green,
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
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.check,
                      color: AppColor.green,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
