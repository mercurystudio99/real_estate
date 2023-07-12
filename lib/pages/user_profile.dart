import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      appBar: AppBar(
        title: Text('Edit Profile'),
        //backgroundColor: Color.fromRGBO(11, 18, 70, 1.0),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Center(
                child: Stack(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      height: 150,
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
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.blue,
                          size: 28.0,
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
              title: Text('First Name'),
              subtitle: Container(
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
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    border:
                        InputBorder.none, // Remove the default TextField border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal:
                            10.0), // Add padding to the TextField content
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Last Name'),
              subtitle: Container(
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
                  decoration: InputDecoration(
                    hintText: 'Last Name',
                    border:
                        InputBorder.none, // Remove the default TextField border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal:
                            10.0), // Add padding to the TextField content
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Location'),
              subtitle: Container(
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
                  decoration: InputDecoration(
                    hintText: 'Location',
                    border:
                        InputBorder.none, // Remove the default TextField border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal:
                            10.0), // Add padding to the TextField content
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Phone'),
              subtitle: Container(
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
                  decoration: InputDecoration(
                    hintText: 'Phone',
                    border:
                        InputBorder.none, // Remove the default TextField border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal:
                            10.0), // Add padding to the TextField content
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Container(
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
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border:
                        InputBorder.none, // Remove the default TextField border
                    contentPadding: EdgeInsets.symmetric(
                        horizontal:
                            10.0), // Add padding to the TextField content
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
