import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:real_estate/utils/common.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/pages/details/components/custom_app_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:real_estate/widgets/custom_image.dart';

class DetailsScreen extends StatefulWidget {
  final String propertyId;

  const DetailsScreen({required this.propertyId});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late String id;
  bool imagesLoaded = false;
  List<Map<String, dynamic>> imageList = [];
  List<Map<String, dynamic>> populars = [];
  List<Map<String, dynamic>> facilities = [];

  @override
  void initState() {
    super.initState();
    id = widget.propertyId;
    populatePopulars(id);
  }

  Future<void> populatePopulars(String propId) async {
    var url = 'https://properties-api.myspacetech.in/ver1/properties/' +
        propId; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["Images"];
        // final List<dynamic> propdetails = json.decode(response.body)["data"];
        // final List<dynamic> propfacilities =
        //     json.decode(response.body)["facilities"];
        List<Map<String, dynamic>> updatedPopulars = [];
        List<Map<String, dynamic>> updatedDetails = [];
        List<Map<String, dynamic>> updatedFacilities = [];

        for (var item in properties) {
          final Map<String, dynamic> newItem = {
            'img_url': item['img_url'],
          };
          updatedPopulars.add(newItem);
        }

        // if (propfacilities != null) {
        //   for (var facility in propfacilities) {
        //     final Map<String, dynamic> newFacility = {
        //       'name': facility['name'],
        //       'distance': facility['distance'],
        //     };
        //     updatedFacilities.add(newFacility);
        //   }
        // }

        // for (var items in propdetails) {
        //   final Map<String, dynamic> newItemdetails = {
        //     'id': items['id'].toString(),
        //     'image': items['image'],
        //     'name': items['title'],
        //     'price': "\₹" + items['price'].toString(),
        //     'location':
        //         (items['address'] ?? "") + ", " + items['location_name'],
        //     'is_favorited': false,
        //     'bed': items['bed'].toString(),
        //     'bathroom': items['bathroom'].toString(),
        //     'square': items['square'].toString(),
        //     'content': items['content'].toString(),
        //     'rooms': items['room'].toString(),
        //   };
        //   updatedDetails.add(newItemdetails);
        // }
        final Map<String, dynamic> newItemdetails = {
          'id': '345234',
          'image': '',
          'name': 'Arlo',
          'price': "\₹4000",
          'location': "new city, MI country",
          'is_favorited': false,
          'bed': '32',
          'bathroom': '12',
          'square': '4',
          'content':
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vulputate vitae nisi bibendum sagittis. Morbi ac suscipit risus. Nulla sollicitudin tortor sapien, vitae bibendum enim rhoncus ut. Donec imperdiet venenatis vulputate. Mauris rutrum, enim ornare fermentum pellentesque, enim lectus consequat velit, ut sagittis nunc mi vel libero. Praesent faucibus diam in mi faucibus cursus. Phasellus sollicitudin, diam vel malesuada commodo, orci erat bibendum ipsum, ut aliquet justo tellus id dui. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Cras egestas mollis enim. Nunc ac ornare dolor, eu volutpat justo. Mauris rhoncus malesuada gravida. Etiam a enim a turpis feugiat maximus. Sed eget velit arcu.',
          'rooms': '6',
        };
        updatedDetails.add(newItemdetails);

        setState(() {
          imageList = updatedPopulars;
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
                    CustomAppBar(),
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
                                      populars[0]['name'].toString(),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                                initialRating: 5,
                                minRating: 1,
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
                              const Text('4.8', style: TextStyle(fontSize: 20)),
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
                                fontSize: 15,
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
                                    // Handle button press
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
    if (facilities != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: facilities.map((facility) {
            return Builder(builder: (BuildContext context) {
              return Stack(children: [
                Text(
                  facility["name"].toString(),
                  style: TextStyle(fontSize: 15, color: AppColor.darker),
                ),
                Text(
                  facility["distance"].toString(),
                  style: TextStyle(fontSize: 15, color: AppColor.darker),
                )
              ]);
            });
          }).toList(),
        ),
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
}
