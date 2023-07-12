import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:real_estate/theme/color.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_estate/utils/common.dart';
import 'package:flutter_html/flutter_html.dart';

class PropertyDetailsPage extends StatefulWidget {
  final String propertyId;

  PropertyDetailsPage({required this.propertyId});

  @override
  _PropertyDetailsPageState createState() => _PropertyDetailsPageState();
}

class _PropertyDetailsPageState extends State<PropertyDetailsPage> {
  late String id;
  bool imagesLoaded = false;
  List<Map<String, dynamic>> imageList = [];
  List<Map<String, dynamic>> populars = [];

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
        final List<dynamic> propdetails = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedPopulars = [];
        List<Map<String, dynamic>> updatedDetails = [];

        for (var item in properties) {
          final Map<String, dynamic> newItem = {
            'img_url': item['img_url'],
          };
          updatedPopulars.add(newItem);
        }

        for (var items in propdetails) {
          final Map<String, dynamic> newItemdetails = {
            'id': items['id'].toString(),
            'image': items['image'],
            'name': items['title'],
            'price': "\₹" + items['price'].toString(),
            'location':
                (items['address'] ?? "") + ", " + items['location_name'],
            'is_favorited': false,
            'bed': items['bed'].toString(),
            'bathroom': items['bathroom'].toString(),
            'square': items['square'].toString(),
            'content': items['content'].toString(),
          };
          updatedDetails.add(newItemdetails);
        }

        setState(() {
          imageList = updatedPopulars;
          populars = updatedDetails;
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
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the shadow
        title: populars.isNotEmpty
            ? Text(populars[0]['name'].toString())
            : Text('Loading...'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              _buildFeaturedImages(),
              SizedBox(height: 16),
              if (populars.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      populars[0]['name'].toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text('Description',
                        style: TextStyle(
                            fontSize: 18,
                            color: AppColor.darker,
                            fontWeight: FontWeight.w500)),
                    Html(
                      data: populars[0]['content'].toString(),
                      style: {
                        'html': Style(
                          fontSize: FontSize(18.0),
                        ),
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      '${populars[0]['price']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bedrooms: ${populars[0]['bed']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bathrooms: ${populars[0]['bathroom']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Area: ${populars[0]['square']} sq. m',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              if (populars.isEmpty) Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedImages() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: false,
        enlargeCenterPage: true,
      ),
      items: imageList.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Stack(
              children: [
                // Actual image or error widget
                Image.network(
                  item['img_url'],
                  fit: BoxFit.cover,
                ),
              ],
            );
          },
        );
      }).toList(),
    );
  }
}
