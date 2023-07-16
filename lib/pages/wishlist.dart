import 'package:flutter/material.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:real_estate/widgets/hot_item.dart';
import 'package:real_estate/widgets/custom_textbox.dart';
import 'package:real_estate/theme/color.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlist = [];

  @override
  void initState() {
    super.initState();
    populateProperties();
  }

  Future<void> _refreshPage() async {
    await populateProperties();
  }

  Future<void> populateProperties() async {
    var url =
        'https://properties-api.myspacetech.in/ver1/properties/recent'; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedPopulars = [];

        for (var item in properties) {
          final Map<String, dynamic> newItem = {
            'id': item['id'].toString(),
            'image': item['image'],
            'name': item['title'],
            'price': "\₹" + item['price'].toString(),
            'location': (item['address'] ?? "") + ", " + item['location_name'],
            'is_favorited': false,
            'bed': item['bed'].toString(),
            'bathroom': item['bathroom'].toString(),
            'square': item['square'].toString(),
            "days_since": item['days_since'].toString(),
            'rooms': item['room'].toString(),
          };
          updatedPopulars.add(newItem);
        }
        setState(() {
          wishlist = updatedPopulars;
        });
      } else {
        // Handle API error
      }
    } catch (error) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: CustomScrollView(
        slivers: <Widget>[SliverToBoxAdapter(child: _buildBody())],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Expanded(
        child: CustomTextBox(
          hint: "Search...",
          prefix: Icon(Icons.search, color: Colors.grey),
          suffix: Icon(Icons.filter_alt, color: Colors.grey),
        ),
      ),
    );
  }

  _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.sort, size: 34, color: Colors.black),
          CustomImage(
            "assets/images/aradhana.png",
            width: 35,
            height: 35,
            trBackground: true,
            borderColor: AppColor.primary,
            radius: 10,
          ),
        ],
      ),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Favorite Properties",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  // MouseRegion(
                  //   cursor: SystemMouseCursors.click,
                  //   child: GestureDetector(
                  //     onTap: () {},
                  //     child: Text(
                  //       "See all",
                  //       style: TextStyle(fontSize: 14, color: AppColor.darker),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildHot(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _buildHot() {
    List<Widget> lists = List.generate(
      wishlist.length,
      (index) => HotItem(
        data: wishlist[index],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: lists),
    );
  }
}
