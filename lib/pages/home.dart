import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/common.dart';
import 'package:real_estate/utils/data.dart';
import 'package:real_estate/widgets/category_item.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:real_estate/widgets/hot_item.dart';
import 'package:real_estate/widgets/spotlight_item.dart';
import 'package:real_estate/widgets/property_item.dart';
import 'package:real_estate/widgets/recent_item.dart';
import 'package:real_estate/widgets/recommend_item.dart';
import 'package:real_estate/pages/explore.dart';
import 'package:real_estate/utils/globals.dart' as global;
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

  late TextEditingController? searchcontroller = TextEditingController();
  late String searchkeyword = '';

  @override
  void initState() {
    super.initState();
    populateAgents();
    populatePopulars();
    populateRecommended();
    populateRecent();
  }

  Future<void> populateAgents() async {
    var url =
        'https://properties-api.myspacetech.in/ver1/users'; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedPopulars = [];
        for (var item in properties) {
          if (item['phone'].toString() == global.phone) {
            global.firstName = item['first_name'];
            global.lastName = item['last_name'];
            global.location = item['address'];
            global.phone = item['phone'];
            global.email = item['email'];
            global.category = item['category'] ?? '';
            global.likes = item['likes'] ?? '';
            if (item['agreepolicy'] > 0) global.policyAgree = true;
          }
          final Map<String, dynamic> newItem = {
            'id': item['id'].toString(),
            'image': item['image'],
            'name': item['name'],
            'first_name': item['first_name'],
            'last_name': item['last_name'],
            'address': item['address'],
            'email': item['email'],
            'phone': item['phone'].toString(),
            'category': item['category'],
            'likes': item['likes'],
            'agreepolicy': item['agreepolicy'],
          };
          updatedPopulars.add(newItem);
        }
        global.users = updatedPopulars;
      } else {
        // Handle API error
      }
    } catch (error) {
      // Handle error
    }
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
            'review_score': item['review_score'] ?? "0.0",
            'category': item['category'],
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
            'category': item['category'],
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
            'category': item['category'],
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
                      navigateToDetailPage(context, "all");
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
                      navigateToDetailPage(context, "all");
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
                      navigateToDetailPage(context, "all");
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
        builder: (context) => ExplorePage(
          listingType: filter,
          independentLayout: true,
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          alignment: Alignment.center,
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.textBoxColor,
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.shadowColor.withOpacity(.05),
                spreadRadius: .5,
                blurRadius: .5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            readOnly: false,
            controller: searchcontroller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: Icon(Icons.filter_alt, color: Colors.grey),
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black)),
              hintText: "Search...",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchkeyword = value;
              });
            },
          ),
        ));
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
    List<Map<String, dynamic>> list = [];
    populars.forEach((element) {
      if (element['name'].contains(searchkeyword)) {
        if (element['category'] == _selectedCategory &&
            _selectedCategory != 0) {
          list.add(element);
        }
        if (_selectedCategory == 0) {
          list.add(element);
        }
      }
    });

    if (list.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No data')));
    } else {
      return CarouselSlider(
        options: CarouselOptions(
          height: 280,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: .8,
        ),
        items: List.generate(
          list.length,
          (index) => PropertyItem(
            data: list[index],
          ),
        ),
      );
    }
  }

  Widget _buildRecommended() {
    List<Map<String, dynamic>> list = [];
    recommended.forEach((element) {
      if (element['name'].contains(searchkeyword)) {
        if (element['category'] == _selectedCategory &&
            _selectedCategory != 0) {
          list.add(element);
        }
        if (_selectedCategory == 0) {
          list.add(element);
        }
      }
    });

    if (list.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No data')));
    } else {
      List<Widget> lists = List.generate(
        list.length,
        (index) => RecommendItem(
          data: list[index],
        ),
      );

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 5, left: 15),
        child: Row(children: lists),
      );
    }
  }

  Widget _buildSpotlight() {
    List<Map<String, dynamic>> list = [];
    recent.forEach((element) {
      if (element['name'].contains(searchkeyword)) {
        if (element['category'] == _selectedCategory &&
            _selectedCategory != 0) {
          list.add(element);
        }
        if (_selectedCategory == 0) {
          list.add(element);
        }
      }
    });

    if (list.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No data')));
    } else {
      List<Widget> lists = List.generate(
        list.length,
        (index) => SpotLightItem(
          data: list[index],
        ),
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: lists),
      );
    }
  }

  Widget _buildTrending() {
    List<Map<String, dynamic>> list = [];
    recent.forEach((element) {
      if (element['name'].contains(searchkeyword)) {
        if (element['category'] == _selectedCategory &&
            _selectedCategory != 0) {
          list.add(element);
        }
        if (_selectedCategory == 0) {
          list.add(element);
        }
      }
    });

    if (list.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No data')));
    } else {
      List<Widget> lists = List.generate(
        list.length,
        (index) => RecentItem(
          data: list[index],
        ),
      );

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(bottom: 5, left: 15),
        child: Row(children: lists),
      );
    }
  }

  Widget _buildHot() {
    List<Map<String, dynamic>> list = [];
    recent.forEach((element) {
      if (element['name'].contains(searchkeyword)) {
        if (element['category'] == _selectedCategory &&
            _selectedCategory != 0) {
          list.add(element);
        }
        if (_selectedCategory == 0) {
          list.add(element);
        }
      }
    });

    if (list.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No data')));
    } else {
      List<Widget> lists = List.generate(
        list.length,
        (index) => HotItem(
          data: list[index],
        ),
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: lists),
      );
    }
  }
}
