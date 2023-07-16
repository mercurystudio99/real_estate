import 'package:flutter/material.dart';
import 'package:real_estate/widgets/custom_image.dart';
import 'package:real_estate/widgets/notification_item.dart';
import 'package:real_estate/theme/color.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    populateNotifications();
  }

  Future<void> _refreshPage() async {
    await populateNotifications();
  }

  Future<void> populateNotifications() async {
    var url =
        'https://properties-api.myspacetech.in/ver1/users'; // Replace with your actual API endpoint URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> properties = json.decode(response.body)["data"];
        List<Map<String, dynamic>> updatedPopulars = [];

        for (var item in properties) {
          final Map<String, dynamic> newItem = {
            'id': item['id'].toString(),
            'image': item['image'],
            'name': item['name'],
            'email': item['email'],
            'phone': item['phone'].toString(),
          };
          updatedPopulars.add(newItem);
        }
        setState(() {
          notifications = updatedPopulars;
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
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _refreshPage,
      child: CustomScrollView(
        slivers: <Widget>[SliverToBoxAdapter(child: _buildBody())],
      ),
    ));
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
              height: 30,
            ),
            _buildHeader(),
            const SizedBox(
              height: 30,
            ),
            _buildNotification(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  _buildNotification() {
    List<Widget> lists = List.generate(
      notifications.length,
      (index) => NotificationItem(
        data: notifications[index],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(children: lists),
    );
  }
}
