import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/constants.dart';

class MProfilePage extends StatefulWidget {
  final String id;
  const MProfilePage({Key? key, required this.id}) : super(key: key);

  @override
  _MProfilePageState createState() => _MProfilePageState();
}

class _MProfilePageState extends State<MProfilePage> {
  late String id;
  final Map<String, dynamic> info = {
    'id': '23',
    'image': '',
    'name': 'Amy Rachel',
    'email': 'kevin@gmail.com',
    'phone': '3423523',
    'location': "new city, MI country",
    'reviews': '34',
    'listings': '4',
  };
  static bool isDocument = false;

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
        // final List<dynamic> properties = json.decode(response.body)["data"];
        // List<Map<String, dynamic>> updatedPopulars = [];

        // for (var item in properties) {
        //   final Map<String, dynamic> newItem = {
        //     'id': item['id'].toString(),
        //     'image': item['image'],
        //     'name': item['name'],
        //     'email': item['email'],
        //     'phone': item['phone'].toString(),
        //   };
        //   updatedPopulars.add(newItem);
        // }
        // setState(() {
        //   agents = updatedPopulars;
        // });
      } else {
        // Handle API error
      }
    } catch (error) {
      // Handle error
    }
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
                        'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
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
                        Container(
                          height: 50,
                          width: 50,
                          child: Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                          ),
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
                      child: Image.asset(
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
                      'listings/portfolio',
                      style:
                          TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Text(
                      info["reviews"] ?? '',
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
                        child: const Text(
                          'portfolio/listings',
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
                      const Text(
                        'Portfolio/listings',
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
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _document() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        tileColor: Colors.blue.shade200.withOpacity(0.5),
        leading: Icon(
          Icons.picture_as_pdf_sharp,
          size: 40,
        ),
        title: const Text('Get started.pdf'),
        subtitle: const Text('13/06/2020 9:58 256.4KB'),
        trailing: Icon(Icons.close),
      ),
    );
  }
}
