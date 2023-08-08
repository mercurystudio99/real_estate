import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/utils/common.dart';
import 'package:real_estate/utils/data.dart';
import 'package:real_estate/widgets/broker_item.dart';
import 'package:real_estate/widgets/company_item.dart';
import 'package:real_estate/widgets/custom_textbox.dart';
import 'package:real_estate/widgets/icon_box.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExplorePage extends StatefulWidget {
  final String listingType;
  final bool independentLayout;
  const ExplorePage(
      {Key? key, required this.listingType, required this.independentLayout})
      : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> listings = [];

  @override
  void initState() {
    super.initState();
    populateListings();
  }

  Future<void> _refreshPage() async {
    await populateListings();
  }

  Future<void> populateListings() async {
    var url = '';
    if (widget.listingType == 'all') {
      url = 'https://properties-api.myspacetech.in/ver1/properties';
    } else {
      url = 'https://properties-api.myspacetech.in/ver1/properties/' +
          widget.listingType;
    }

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
            'address': (item['address'] ?? ""),
            'location': item['location_name'],
            'is_favorited': false,
            'bed': item['bed'].toString(),
            'bathroom': item['bathroom'].toString(),
            'square': item['square'].toString(),
            'search_class': item['search_class'],
          };
          updatedPopulars.add(newItem);
        }
        setState(() {
          listings = updatedPopulars;
        });
      } else {
        // AppCommons.showErrorPopup(context,
        //     'Failed to retrieve data from the API. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // AppCommons.showErrorPopup(
      //     context, 'Error occurred while fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.independentLayout
        ? Scaffold(
            body: RefreshIndicator(
            onRefresh: _refreshPage,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: AppColor.appBgColor,
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: _buildHeader(),
                ),
                SliverToBoxAdapter(child: _buildBody())
              ],
            ),
          ))
        : RefreshIndicator(
            onRefresh: _refreshPage,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: AppColor.appBgColor,
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: _buildHeader(),
                ),
                SliverToBoxAdapter(child: _buildBody())
              ],
            ),
          );
  }

  _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: CustomTextBox(
            hint: "Search",
            prefix: Icon(Icons.search, color: Colors.grey),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const SizedBox(width: 50)
        // IconBox(
        //   child: Icon(Icons.filter_list_rounded, color: Colors.white),
        //   bgColor: AppColor.secondary,
        //   radius: 10,
        // )
      ],
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
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "Agencies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildCompanies(),
                const SizedBox(
                  height: 20,
                ),
                _buildBrokers(),
                const SizedBox(
                  height: 100,
                ),
              ],
            )));
  }

  int _selectedCategory = 0;
  _buildCompanies() {
    List<Widget> lists = List.generate(
      companies.length,
      (index) => CompanyItem(
        data: companies[index],
        color: AppColor.listColors[index % 10],
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

  _buildBrokers() {
    List<Map<String, dynamic>> list = [];
    listings.forEach((element) {
      if (element['search_class'] == _selectedCategory) {
        list.add(element);
      }
    });

    if (list.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          Center(child: const Text('No data', style: TextStyle(fontSize: 20)))
        ]),
      );
    } else {
      List<Widget> lists = List.generate(
        list.length,
        (index) => BrokerItem(
          data: list[index],
        ),
      );

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: lists),
      );
    }
  }
}
