import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:real_estate/utils/common.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/constants.dart';
import 'package:real_estate/utils/globals.dart' as global;
import 'package:flutter_html/flutter_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailsScreen extends StatefulWidget {
  final String propertyId;

  const DetailsScreen({required this.propertyId});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late String id;
  late String userID;
  late bool isLike = false;
  bool imagesLoaded = false;
  List<Map<String, dynamic>> imageList = [];
  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> populars = [];
  List<Map<String, dynamic>> facilities = [];

  late TextEditingController? reviewController = TextEditingController();

  String fileurl =
      "https://aradhana.myspacetech.in/uploads/0000/1/2023/02/20/floor21.pdf";

  @override
  void initState() {
    super.initState();
    id = widget.propertyId;
    populatePopulars(id);
    List<String> likes = global.likes.split(',');
    likes.forEach((element) {
      if (element == id) {
        isLike = true;
      }
    });

    global.users.forEach((element) {
      if (element['phone'] == global.phone) {
        userID = element['id'];
      }
    });
  }

  Future<void> _setFavorite() async {
    List<String> likes = global.likes.split(',');
    if (isLike) {
      likes.remove(id);
    } else {
      likes.add(id);
    }

    Map<String, String> formData = {
      "phone": global.phone,
      "likes": likes.join(','),
    };

    final response = await http.post(
        Uri.parse('https://properties-api.myspacetech.in/ver1/updatelikes/'),
        body: formData);
    global.likes = likes.join(',');
    isLike = !isLike;
    setState(() {});
  }

  Future<void> _postReview() async {
    Map<String, String> formData = {
      "phone": global.phone,
      "object_id": id,
      "title": '',
      "review": reviewController!.text.trim(),
      "rating": '0',
    };

    final response = await http.post(
        Uri.parse('https://properties-api.myspacetech.in/ver1/addreview/'),
        body: formData);
  }

  Future<void> _updateReviews(String id) async {
    Map<String, String> formData = {
      "phone": global.phone,
      "id": id,
    };
    final response = await http.post(
        Uri.parse('https://properties-api.myspacetech.in/ver1/updatereview/'),
        body: formData);

    List<Map<String, dynamic>> tempList = [];
    reviews.forEach((element) {
      if (element['id'].toString() == id) {
        if (element['likes'] == null) {
          final Map<String, dynamic> newItem = {
            'id': element['id'],
            'title': element['title'],
            'content': element['content'],
            'rate_number': element['rate_number'] ?? 0,
            'publish_date': element['publish_date'],
            'vendor_id': element['vendor_id'],
            'likes': '$userID,',
          };
          tempList.add(newItem);
        } else {
          if (element['likes'].toString().contains(userID)) {
            final Map<String, dynamic> newItem = {
              'id': element['id'],
              'title': element['title'],
              'content': element['content'],
              'rate_number': element['rate_number'] ?? 0,
              'publish_date': element['publish_date'],
              'vendor_id': element['vendor_id'],
              'likes': element['likes'].replaceAll('$userID,', ''),
            };
            tempList.add(newItem);
          } else {
            final Map<String, dynamic> newItem = {
              'id': element['id'],
              'title': element['title'],
              'content': element['content'],
              'rate_number': element['rate_number'] ?? 0,
              'publish_date': element['publish_date'],
              'vendor_id': element['vendor_id'],
              'likes': element['likes'] + userID + ',',
            };
            tempList.add(newItem);
          }
        }
      } else {
        tempList.add(element);
      }
    });
    reviews = [];
    reviews = tempList;
    setState(() {});
  }

  Future<void> populatePopulars(String propId) async {
    var url = 'https://properties-api.myspacetech.in/ver1/properties/' +
        propId; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["Images"];
        final List<dynamic> reviewss = json.decode(response.body)["reviews"];
        final Map<String, dynamic> propdetails =
            json.decode(response.body)["data"][0];
        final List<dynamic> propfacilities =
            propdetails['facilities'] != "" ? propdetails['facilities'] : [];
        List<Map<String, dynamic>> updatedPopulars = [];
        List<Map<String, dynamic>> updatedReviews = [];
        List<Map<String, dynamic>> updatedDetails = [];
        List<Map<String, dynamic>> updatedFacilities = [];

        for (var item in properties) {
          final Map<String, dynamic> newItem = {
            'img_url': item['img_url'],
          };
          updatedPopulars.add(newItem);
        }

        if (reviewss.isNotEmpty) {
          for (var item in reviewss) {
            final Map<String, dynamic> newItem = {
              'id': item['id'],
              'title': item['title'],
              'content': item['content'],
              'rate_number': item['rate_number'] ?? 0,
              'publish_date': item['publish_date'],
              'vendor_id': item['vendor_id'],
              'likes': item['likes'],
            };
            updatedReviews.add(newItem);
          }
        }

        for (var facility in propfacilities) {
          final Map<String, dynamic> newFacility = {
            'name': facility['name'],
            'distance': facility['distance'],
          };
          updatedFacilities.add(newFacility);
        }

        final Map<String, dynamic> newItemdetails = {
          'id': propdetails['id'].toString(),
          'image': propdetails['image'],
          'name': propdetails['title'].toString(),
          'price': "\₹" + propdetails['price'].toString(),
          'location': (propdetails['address'] ?? "") +
              ", " +
              propdetails['location_name'],
          'is_favorited': false,
          'bed': propdetails['bed'].toString(),
          'bathroom': propdetails['bathroom'].toString(),
          'square': propdetails['square'].toString(),
          'content': propdetails['content'].toString(),
          'rooms': propdetails['room'].toString() == 'null'
              ? "0"
              : propdetails['room'].toString(),
          'review_score': propdetails['review_score'] ?? "0.0",
          'documents': propdetails['documents'],
        };
        updatedDetails.add(newItemdetails);

        setState(() {
          imageList = updatedPopulars;
          reviews = updatedReviews;
          populars = updatedDetails;
          facilities = updatedFacilities;
        });
      } else {
        AppCommons.showErrorPopup(context,
            'Failed to retrieve data from the API. Status code: ${response.statusCode}');
      }
    } catch (error) {
      AppCommons.showErrorPopup(
          context, 'Error occurred while fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    int titleLength = 20;
    if (populars.isNotEmpty && populars[0]['documents'] != null)
      titleLength = 16;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    _buildFeaturedImages(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: appPadding,
                        right: appPadding,
                        top: appPadding,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.1,
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
                                  color: white,
                                ),
                              ),
                            ),
                            InkWell(
                                onTap: _setFavorite,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Icon(
                                    isLike
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: Colors.red,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    _buildFeaturedThumbnails(),
                  ],
                ),

                //HouseDetails(widget.house),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (populars.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      populars[0]['name'].toString().length >
                                              titleLength
                                          ? populars[0]['name']
                                                  .toString()
                                                  .substring(
                                                      0, titleLength - 4) +
                                              '...'
                                          : populars[0]['name'].toString(),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (populars[0]['documents'] != null)
                                      IconButton(
                                          onPressed: () async {
                                            Map<Permission, PermissionStatus>
                                                statuses = await [
                                              Permission.storage,
                                              //add more permission to request here.
                                            ].request();

                                            if (statuses[Permission.storage]!
                                                .isGranted) {
                                              String savename = "download.pdf";
                                              String savePath =
                                                  "/storage/emulated/0/Download/$savename";
                                              try {
                                                await Dio()
                                                    .download(fileurl, savePath,
                                                        onReceiveProgress:
                                                            (received, total) {
                                                  if (total != -1) {
                                                    debugPrint((received /
                                                                total *
                                                                100)
                                                            .toStringAsFixed(
                                                                0) +
                                                        "%");
                                                    //you can build progressbar feature too
                                                  }
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'File is saved to download folder.')),
                                                );
                                              } on DioException catch (e) {
                                                debugPrint(e.message);
                                              }
                                            } else {
                                              debugPrint(
                                                  "No permission to read and write.");
                                            }
                                          },
                                          icon: Icon(Icons.file_download_sharp,
                                              color: AppColor.primary)),
                                    Icon(Icons.share, color: AppColor.primary)
                                  ]),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.place_sharp,
                                  color: AppColor.primary,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  populars[0]["location"],
                                  style: TextStyle(
                                      fontSize: 18, color: AppColor.darker),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(children: [
                              RatingBar.builder(
                                initialRating:
                                    double.parse(populars[0]['review_score']),
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemSize: 25,
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber.shade300,
                                ),
                                onRatingUpdate: (rating) {},
                              ),
                              const SizedBox(width: 10),
                              Text(populars[0]['review_score'] ?? '0.0',
                                  style: TextStyle(fontSize: 20)),
                            ]),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(width: 10),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColor
                                                .primary, // Set the border color here
                                            width:
                                                2.0, // Set the border width if needed
                                          ) // Replace with your desired circle color
                                          ),
                                      child: Icon(
                                        Icons.home,
                                        color: AppColor.primary,
                                        size: 25.0,
                                      ),
                                    ),
                                    Text(populars[0]["rooms"] + " Rooms",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.darker)),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColor
                                                .primary, // Set the border color here
                                            width:
                                                2.0, // Set the border width if needed
                                          ) // Replace with your desired circle color
                                          ),
                                      child: Icon(
                                        Icons.hotel,
                                        color: AppColor.primary,
                                        size: 25.0,
                                      ),
                                    ),
                                    Text(populars[0]["bed"] + " Beds",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.darker)),
                                  ],
                                ),
                                const SizedBox(width: 24),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColor
                                                .primary, // Set the border color here
                                            width:
                                                2.0, // Set the border width if needed
                                          ) // Replace with your desired circle color
                                          ),
                                      child: Icon(
                                        Icons.square_foot,
                                        color: AppColor.primary,
                                        size: 25.0,
                                      ),
                                    ),
                                    Text(populars[0]["square"] + " m sq",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.darker)),
                                  ],
                                ),
                                const SizedBox(width: 24),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      margin: EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColor
                                                .primary, // Set the border color here
                                            width:
                                                2.0, // Set the border width if needed
                                          ) // Replace with your desired circle color
                                          ),
                                      child: Icon(
                                        Icons.bathtub,
                                        color: AppColor.primary,
                                        size: 25.0,
                                      ),
                                    ),
                                    Text(populars[0]["bathroom"] + " Baths",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.darker)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7),
                              child: Text('Description',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Html(
                              data: populars[0]['content'].toString(),
                              style: {
                                'html': Style(
                                  fontSize: FontSize(18.0),
                                ),
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Facilities",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            _buildFacilities(),
                            SizedBox(height: 10),
                            SizedBox(height: 30),
                            ListTile(
                              leading: CustomImage(
                                'https://properties-api.myspacetech.in/aradhana.png',
                                width: 50,
                                height: 50,
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Christopher Kabugo',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Agent',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton.icon(
                                  onPressed: () {
                                    if (global.policyAgree) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'You can send a message.')));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'You must agree to the Privacy Policy.')));
                                    }
                                  },
                                  icon: Icon(
                                    Icons.message,
                                    size: 12,
                                  ),
                                  label: Text('Message',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor
                                        .primary, // Set the button color to red
                                  )),
                            ),
                            _buildReviews()
                          ],
                        ),
                      if (populars.isEmpty)
                        Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildFacilities() {
    if (facilities.isNotEmpty) {
      List<Map<String, dynamic>> evenIndexElements = [];
      List<Map<String, dynamic>> oddIndexElements = [];
      facilities.asMap().forEach((key, val) {
        if (key % 2 == 0) {
          evenIndexElements.add(val);
        } else {
          oddIndexElements.add(val);
        }
      });

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Column(
                  children: evenIndexElements.map((facility) {
            return Builder(builder: (BuildContext context) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_city, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          facility["name"].toString(),
                          style:
                              TextStyle(fontSize: 16, color: AppColor.darker),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          facility["distance"].toString(),
                          style:
                              TextStyle(fontSize: 15, color: AppColor.darker),
                        )
                      ]));
            });
          }).toList())),
          const SizedBox(width: 15),
          Expanded(
              child: Column(
                  children: oddIndexElements.map((facility) {
            return Builder(builder: (BuildContext context) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_city, size: 30),
                        const SizedBox(width: 10),
                        Text(
                          facility["name"].toString(),
                          style:
                              TextStyle(fontSize: 16, color: AppColor.darker),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          facility["distance"].toString(),
                          style:
                              TextStyle(fontSize: 15, color: AppColor.darker),
                        )
                      ]));
            });
          }).toList()))
        ]),
      );
    } else {
      return Center(child: Text("No available facilities"));
    }
  }

  int currentImageIndex = 0;
  CarouselController carouselController = CarouselController();
  Widget _buildFeaturedImages() {
    Size size = MediaQuery.of(context).size;
    double sliderHeight = size.height * 0.35;
    double sliderWidth = size.width - 32;
    double imageHeight = sliderHeight;
    double imageWidth = sliderWidth;
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          height: sliderHeight,
          width: sliderWidth,
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: CarouselSlider(
            carouselController: carouselController,
            options: CarouselOptions(
              viewportFraction: 1.0,
              height: sliderHeight,
              autoPlay: false,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  currentImageIndex = index;
                });
              },
            ),
            items: imageList.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: imageHeight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item['img_url'],
                            fit: BoxFit.cover,
                            height: imageHeight,
                            width: imageWidth,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedThumbnails() {
    Size size = MediaQuery.of(context).size;
    double imageHeight = size.width * 0.2;
    double imageWidth = size.width * 0.2;

    List<Widget> thumbnail = imageList.map((item) {
      int more = imageList.length > 4 ? imageList.length - 4 : imageList.length;
      return Container(
        width: imageWidth,
        height: imageHeight,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Stack(children: [
            Image.network(item['img_url'],
                fit: BoxFit.cover, width: imageWidth, height: imageHeight),
            if (imageList.length > 4 && imageList.indexOf(item) == 3)
              Container(color: Colors.black.withOpacity(0.5)),
            if (imageList.length > 4 && imageList.indexOf(item) == 3)
              Center(
                child: Text(
                  '$more+',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              )
          ]),
        ),
      );
    }).toList();
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: size.height * 0.325),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: thumbnail.length > 4 ? thumbnail.sublist(0, 4) : thumbnail,
        ));
  }

  Widget _buildReviews() {
    if (reviews.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Center(child: const Text('No reviews')));
    } else {
      Map<String, dynamic> review = reviews[0];
      String name = '';
      String avatar = '';
      global.users.forEach((element) {
        if (element['id'].toString() == review['vendor_id'].toString()) {
          name = element['name'];
          avatar = element['image'];
        }
      });
      return SizedBox(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
          child: Column(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text('Reviews',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 5),
              leading: CustomImage(
                (avatar == '')
                    ? 'https://properties-api.myspacetech.in/aradhana.png'
                    : avatar,
                width: 30,
                height: 30,
              ),
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Html(
              data: review['content'],
              style: {
                'html': Style(
                  fontSize: FontSize(18.0),
                ),
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
                onTap: () {
                  getAllReviews(onSuccess: (List<Widget> param) {
                    _showAllReviewDialog(param);
                  });
                  // Navigator.restorablePush<void>(context, _fullscreenDialogRoute);
                },
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text('See All Reviews',
                        style:
                            TextStyle(color: AppColor.primary, fontSize: 15)))),
          ]),
        ),
      );
    }
  }

  void getAllReviews({required Function(List<Widget>) onSuccess}) {
    final List<Widget> topbar = [
      Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Column(children: [
          const SizedBox(height: 40),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, color: Colors.white),
                  ))),
          const SizedBox(height: 40)
        ]),
      )
    ];
    final List<Widget> reviewList = [];

    reviews.forEach((review) {
      String name = '';
      String avatar = '';
      int count = 0;
      if (review['likes'] != null) {
        count = review['likes'].toString().split(',').length - 1;
      }
      global.users.forEach((element) {
        if (element['id'].toString() == review['vendor_id'].toString()) {
          name = element['name'];
          avatar = element['image'];
        }
      });
      Widget view = Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Column(children: [
                ListTile(
                  contentPadding: EdgeInsets.only(left: 5),
                  leading: CustomImage(
                    (avatar == '')
                        ? 'https://properties-api.myspacetech.in/aradhana.png'
                        : avatar,
                    width: 30,
                    height: 30,
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Html(
                  data: review['content'],
                  style: {
                    'html': Style(
                      fontSize: FontSize(18.0),
                    ),
                  },
                ),
                const SizedBox(height: 10),
                Row(children: [
                  Text(
                    (review['publish_date'] == null)
                        ? ''
                        : review['publish_date'].toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        _updateReviews(review['id'].toString());
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        (count > 0) ? Icons.favorite : Icons.favorite_outline,
                        color: Colors.red,
                      )),
                  if (count > 0) const SizedBox(width: 10),
                  if (count > 0) Text('$count'),
                  const SizedBox(width: 40),
                  Icon(Icons.messenger_outline_rounded)
                ]),
                const SizedBox(height: 10)
              ])));
      reviewList.add(view);
    });

    final List<Widget> result = [...topbar, ...reviewList];
    onSuccess(result);
  }

  Future<void> _showAllReviewDialog(List<Widget> param) async {
    await showGeneralDialog<void>(
        context: context,
        transitionDuration: Duration(milliseconds: 400),
        pageBuilder: (bc, ania, anis) {
          return SizedBox.expand(
            child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Stack(alignment: Alignment.bottomRight, children: [
                  ListView(children: param),
                  Positioned(
                      bottom: 80,
                      right: 20,
                      child: FloatingActionButton(
                          backgroundColor: AppColor.primary,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 50),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Add Review',
                                                style: TextStyle(fontSize: 24),
                                              ))),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          child: TextField(
                                            controller: reviewController,
                                            decoration: InputDecoration(
                                                hintText: 'Enter Message'),
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 3,
                                          )),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 20),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColor
                                                        .primary,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5)),
                                                onPressed: () {
                                                  _postReview();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  'Send',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.0),
                                                ),
                                              )))
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(Icons.edit_outlined)))
                ])),
          );
        });
  }

  static Route<void> _fullscreenDialogRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return MaterialPageRoute<void>(
      builder: (context) => _FullScreenDialogDemo(),
      fullscreenDialog: true,
    );
  }
}

class _FullScreenDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Icon(Icons.heart_broken)));
  }
}
