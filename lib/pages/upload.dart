import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/theme/color.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late List<XFile> imageList = [];

  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource media, BuildContext context) async {
    var img = await picker.pickImage(source: media);
    Navigator.pop(context);
    setState(() {
      imageList.add(img!);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> lists = imageList.map((item) {
      return Container(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(item.path),
            fit: BoxFit.cover,
            width: (MediaQuery.of(context).size.width - 120) / 3,
            height: (MediaQuery.of(context).size.width - 120) / 3,
          ),
        ),
      ));
    }).toList();
    lists.add(Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary.withOpacity(0.05),
                elevation: 10, //elevation of button
                shape: RoundedRectangleBorder(
                    //to set border radius to button
                    borderRadius: BorderRadius.circular(5)),
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(5) //content padding inside button
                ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.photo),
                        title: Text('Gallery'),
                        onTap: () {
                          getImage(ImageSource.gallery, context);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.camera),
                        title: Text('Camera'),
                        onTap: () {
                          getImage(ImageSource.camera, context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              '+',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )),
    ));

    int rowCount = lists.length ~/ 3;
    List<Widget> rowList = [
      Row(children: [const SizedBox(height: 60)]),
      Row(children: [
        const SizedBox(width: 20),
        InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.arrow_back_ios))
      ]),
      Row(children: [const SizedBox(height: 20)]),
    ];
    for (int i = 0; i < rowCount + 1; i++) {
      if (lists.length > 3 * (i + 1)) {
        rowList.add(Row(children: lists.sublist(3 * i, 3 * (i + 1))));
      } else {
        rowList.add(Row(children: lists.sublist(3 * i, lists.length)));
      }
    }

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary.withOpacity(0.05),
                      elevation: 10, //elevation of button
                      shape: RoundedRectangleBorder(
                          //to set border radius to button
                          borderRadius: BorderRadius.circular(5)),
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.all(
                          5) //content padding inside button
                      ),
                  onPressed: () {},
                  child: const Text(
                    'Save Draft',
                    style: TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                )),
                const SizedBox(width: 20),
                Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          shadowColor: Colors.black.withOpacity(0.4),
                          padding: const EdgeInsets.all(5)),
                      onPressed: () {},
                      child: const Text(
                        'Post',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )),
              ],
            ),
          ),
        ),
        body: Stack(alignment: Alignment.bottomCenter, children: [
          SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowList,
          )),
        ]));
  }
}
