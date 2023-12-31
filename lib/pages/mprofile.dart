import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/constants.dart';
import 'package:real_estate/widgets/hot_item.dart';

class MProfilePage extends StatefulWidget {
  final String id;
  const MProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  _MProfilePageState createState() => _MProfilePageState();
}

class _MProfilePageState extends State<MProfilePage> {
  late String id;
  late String _memberType = '';
  late List<Map<String, dynamic>> imageList = [];
  List<Map<String, dynamic>> populars = [];
  late Map<String, dynamic> info = {
    'id': '',
    'image': null,
    'name': '',
    'email': '',
    'phone': '',
    'location': '',
    'reviews': 0,
    'listings': '0',
  };
  static bool isDocument = false;
  late bool existDocument = false;
  String fileurl =
      "https://aradhana.myspacetech.in/uploads/0000/1/2023/02/20/floor21.pdf";

  @override
  void initState() {
    super.initState();
    id = widget.id;
    agent(id);
  }

  // Future<void> _refreshPage() async {
  //   await agent();
  // }

  Future<void> agent(String id) async {
    var url = 'https://properties-api.myspacetech.in/ver1/users/' +
        id; // Replace with your actual API endpoint URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> gallery = json.decode(response.body)["Images"];
        final List<dynamic> reviews = json.decode(response.body)["reviews"];
        final Map<String, dynamic> detail =
            json.decode(response.body)["data"][0];

        List<Map<String, dynamic>> galleryList = [];
        if (gallery.isNotEmpty) {
          for (var item in gallery) {
            final Map<String, dynamic> newItem = {
              'img_url': item['img_url'],
            };
            galleryList.add(newItem);
          }
        }

        info['id'] = detail['id'].toString();
        info['image'] = detail['image'];
        info['name'] = detail['name'];
        info['email'] = detail['email'];
        info['phone'] = detail['phone'];
        info['listings'] = galleryList.length.toString();
        info['reviews'] = reviews.length;
        _memberType = detail['category'] ?? '';
        imageList = galleryList;

        setState(() {});
        populatePopulars(id);
      } else {
        // Handle API error
      }
    } catch (error) {
      // Handle error
    }
  }

  Future<void> populatePopulars(String userId) async {
    var url =
        'https://properties-api.myspacetech.in/ver1/properties/recent'; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedPopulars = [];
        bool isDocument = false;

        for (var item in properties) {
          if (userId == item['create_user'].toString()) {
            final Map<String, dynamic> newItem = {
              'id': item['id'].toString(),
              'image': item['image'],
              'name': item['title'],
              'price': "\₹" + item['price'].toString(),
              'location':
                  (item['address'] ?? "") + ", " + item['location_name'],
              'is_favorited': false,
              'bed': item['bed'].toString(),
              'bathroom': item['bathroom'].toString(),
              'square': item['square'].toString(),
              "days_since": item['days_since'].toString(),
              'rooms': item['room'].toString(),
              'category': item['category'],
            };
            updatedPopulars.add(newItem);
            if (item['documents'] != null && item['documents'] != '') {
              isDocument = true;
            }
          }
        }
        setState(() {
          if (_memberType != 'vendor') {
            info['listings'] = updatedPopulars.length.toString();
          }
          populars = updatedPopulars;
          existDocument = isDocument;
        });
      } else {}
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double avatarPosY = 200;
    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(children: [
        Column(
          children: [
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width,
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(500, 200),
                            bottomRight: Radius.elliptical(500, 200))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.elliptical(500, 200),
                          bottomRight: Radius.elliptical(500, 200)),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: appPadding,
                  ),
                  child: Container(
                    height: size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: avatarPosY),
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 4, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child: (info["image"] != null)
                          ? Image.network(info["image"],
                              width: 100, height: 100, fit: BoxFit.cover)
                          : Image.asset(
                              'assets/images/aradhana.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: avatarPosY + 10, left: size.width * 0.3),
                  alignment: Alignment.center,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        color: AppColor.secondary,
                        border: Border.all(width: 3, color: Colors.white),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                info["name"],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.grey.shade700),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, bottom: 20),
              child: Text(
                info["location"],
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      info["listings"] ?? '',
                      style:
                          TextStyle(fontSize: 34, color: Colors.grey.shade700),
                    ),
                    Text(
                      (_memberType == 'vendor') ? 'portfolio' : 'listings',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Text(
                      info["reviews"].toString(),
                      style:
                          TextStyle(fontSize: 34, color: Colors.grey.shade700),
                    ),
                    Text(
                      'Reviews',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 120,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.all(5)),
                        onPressed: () {
                          setState(() {
                            isDocument = false;
                          });
                        },
                        child: Text(
                          (_memberType == 'vendor') ? 'portfolio' : 'listings',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      )),
                  SizedBox(
                      width: 120,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.all(5)),
                        onPressed: () {
                          setState(() {
                            isDocument = true;
                          });
                        },
                        child: const Text(
                          'documents',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                        ),
                      )),
                ],
              ),
            ),
            isDocument
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Icon(
                        Icons.picture_as_pdf,
                        color: Colors.grey,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Documents',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )
                    ]))
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      const Icon(
                        Icons.image_outlined,
                        color: Colors.grey,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        (_memberType == 'vendor') ? 'portfolio' : 'listings',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      )
                    ])),
            isDocument ? _document() : _listing(),
          ],
        )
      ]),
    ));
  }

  Widget _listing() {
    if (_memberType == 'vendor') {
      Size size = MediaQuery.of(context).size;

      List<Widget> lists = imageList.map((item) {
        return Container(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item['img_url'],
              fit: BoxFit.cover,
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
          ),
        ));
      }).toList();
      int rowCount = lists.length ~/ 2;
      List<Widget> rowList = [
        Row(children: [const SizedBox(height: 10)]),
      ];
      for (int i = 0; i < rowCount + 1; i++) {
        if (lists.length > 2 * (i + 1)) {
          rowList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: lists.sublist(2 * i, 2 * (i + 1))));
        } else {
          rowList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: lists.sublist(2 * i, lists.length)));
        }
      }

      return Container(
        width: size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowList),
      );
    } else {
      return _buildHot();
    }
  }

  Widget _document() {
    if (existDocument) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          tileColor: Colors.blue.shade200.withOpacity(0.5),
          leading: Icon(
            Icons.picture_as_pdf_sharp,
            size: 40,
          ),
          title: const Text('floor21.pdf'),
          // subtitle: const Text('13/06/2020 9:58 256.4KB'),
          trailing: IconButton(
              onPressed: () async {
                Map<Permission, PermissionStatus> statuses = await [
                  Permission.storage,
                  //add more permission to request here.
                ].request();

                if (statuses[Permission.storage]!.isGranted) {
                  String savename = "floor21.pdf";
                  String savePath = "/storage/emulated/0/Download/$savename";
                  try {
                    await Dio().download(fileurl, savePath,
                        onReceiveProgress: (received, total) {
                      if (total != -1) {
                        debugPrint(
                            (received / total * 100).toStringAsFixed(0) + "%");
                        //you can build progressbar feature too
                      }
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('File is saved to download folder.')),
                    );
                  } on DioException catch (e) {
                    debugPrint(e.message);
                  }
                } else {
                  debugPrint("No permission to read and write.");
                }
              },
              icon: Icon(Icons.file_download_sharp, color: AppColor.primary)),
        ),
      );
    } else {
      return SizedBox(height: 1);
    }
  }

  Widget _buildHot() {
    if (populars.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No data')));
    } else {
      List<Widget> lists = List.generate(
        populars.length,
        (index) => HotItem(
          data: populars[index],
        ),
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: lists),
      );
    }
  }
}
