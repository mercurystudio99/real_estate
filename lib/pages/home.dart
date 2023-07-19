import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/common.dart';
import 'package:real_estate/utils/data.dart';
import 'package:real_estate/widgets/category_item.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:real_estate/widgets/custom_textbox.dart';
import 'package:real_estate/widgets/hot_item.dart';
import 'package:real_estate/widgets/spotlight_item.dart';
import 'package:real_estate/widgets/property_item.dart';
import 'package:real_estate/widgets/recent_item.dart';
import 'package:real_estate/widgets/recommend_item.dart';
import 'package:real_estate/pages/explore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> populars = [];
  List<Map<String, dynamic>> recommended = [];
  List<Map<String, dynamic>> recent = [];

  @override
  void initState() {
    super.initState();
    populatePopulars();
    populateRecommended();
    populateRecent();
  }

  Future<void> populatePopulars() async {
    var url =
        'https://properties-api.myspacetech.in/ver1/properties'; // Replace with your actual API endpoint URL

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
            'rooms': item['room'].toString(),
          };
          updatedPopulars.add(newItem);
        }
        setState(() {
          populars = updatedPopulars;
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

  Future<void> populateRecent() async {
    var url =
        'https://properties-api.myspacetech.in/ver1/properties/recent'; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedRecent = [];

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
          updatedRecent.add(newItem);
        }
        setState(() {
          recent = updatedRecent;
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

  Future<void> populateRecommended() async {
    var url =
        'https://properties-api.myspacetech.in/ver1/properties/recommended'; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedRecommended = [];

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
            'rooms': item['room'].toString(),
          };
          updatedRecommended.add(newItem);
        }
        setState(() {
          recommended = updatedRecommended;
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

  Future<void> _refreshPage() async {
    await populatePopulars();
    await populateRecent();
    await populateRecommended();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshPage,
      child: CustomScrollView(
        slivers: <Widget>[
          // SliverAppBar(
          //   leading: const Icon(Icons.sort, size: 34, color: Colors.black),
          //   backgroundColor: Colors.white,
          //   pinned: true,
          //   snap: true,
          //   floating: true,
          //   title: _buildHeader(),
          // ),
          SliverToBoxAdapter(child: _buildBody())
        ],
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
            profile,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          _buildHeader(),
          const SizedBox(
            height: 15,
          ),
          _buildSearch(),
          const SizedBox(
            height: 20,
          ),
          _buildCategories(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Featured Listings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to another page here
                    navigateToDetailPage(context, "all");
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(fontSize: 15, color: AppColor.darker),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildPopulars(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to another page here
                    navigateToDetailPage(context, "recommended");
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(fontSize: 14, color: AppColor.darker),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildRecommended(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Spotlights",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to another page here
                      navigateToDetailPage(context, "spotlight");
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(fontSize: 14, color: AppColor.darker),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildSpotlight(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Trending Properties",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to another page here
                      navigateToDetailPage(context, "trending");
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(fontSize: 14, color: AppColor.darker),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _buildTrending(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hot Properties",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to another page here
                      navigateToDetailPage(context, "hot");
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(fontSize: 14, color: AppColor.darker),
                    ),
                  ),
                ),
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
    );
  }

  void navigateToDetailPage(BuildContext context, String filter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExplorePage(listingType: filter),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomTextBox(
        hint: "Search...",
        prefix: Icon(Icons.search, color: Colors.grey),
        suffix: Icon(Icons.filter_alt, color: Colors.grey),
      ),
    );
  }

  int _selectedCategory = 0;
  Widget _buildCategories() {
    List<Widget> lists = List.generate(
      categories.length,
      (index) => CategoryItem(
        data: categories[index],
        selected: index == _selectedCategory,
        onTap: () {
          setState(() {
            _selectedCategory = index;
          });
        },
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildPopulars() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 280,
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: .8,
      ),
      items: List.generate(
        populars.length,
        (index) => PropertyItem(
          data: populars[index],
        ),
      ),
    );
  }

  Widget _buildRecommended() {
    List<Widget> lists = List.generate(
      recommended.length,
      (index) => RecommendItem(
        data: recommended[index],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildSpotlight() {
    List<Widget> lists = List.generate(
      recent.length,
      (index) => SpotLightItem(
        data: recent[index],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: lists),
    );
  }

  Widget _buildTrending() {
    List<Widget> lists = List.generate(
      recent.length,
      (index) => RecentItem(
        data: recent[index],
      ),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(bottom: 5, left: 15),
      child: Row(children: lists),
    );
  }

  Widget _buildHot() {
    List<Widget> lists = List.generate(
      recent.length,
      (index) => HotItem(
        data: recent[index],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: lists),
    );
  }
}
