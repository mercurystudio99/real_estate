import 'package:flutter/material.dart';
import 'package:real_estate/widgets/agent_items.dart';
import 'package:real_estate/widgets/custom_textbox.dart';
import 'package:real_estate/utils/globals.dart' as global;
import 'dart:convert';
import 'package:http/http.dart' as http;

class AgentsPage extends StatefulWidget {
  const AgentsPage({Key? key}) : super(key: key);

  @override
  _AgentsPageState createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  List<Map<String, dynamic>> agents = [];

  @override
  void initState() {
    super.initState();
    populateAgents();
  }

  Future<void> _refreshPage() async {
    await populateAgents();
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
          final Map<String, dynamic> newItem = {
            'id': item['id'].toString(),
            'image': item['image'],
            'name': item['name'],
            'email': item['email'],
            'phone': item['phone'].toString(),
          };
          updatedPopulars.add(newItem);
        }
        global.users = updatedPopulars;
        setState(() {
          agents = updatedPopulars;
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
    return RefreshIndicator(onRefresh: _refreshPage, child: _buildBody()
        // CustomScrollView(
        //   slivers: <Widget>[
        //     // SliverAppBar(
        //     //   backgroundColor: AppColor.appBgColor,
        //     //   pinned: true,
        //     //   snap: true,
        //     //   floating: true,
        //     //   title: _buildHeader(),
        //     // ),
        //     SliverToBoxAdapter(child: _buildBody())
        //   ],
        // ),
        );
  }

  // _buildSearch() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: CustomTextBox(
  //           hint: "Search",
  //           prefix: Icon(Icons.search, color: Colors.grey),
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 10,
  //       ),
  //       IconBox(
  //         child: Icon(Icons.filter_list_rounded, color: Colors.white),
  //         bgColor: AppColor.secondary,
  //         radius: 10,
  //       )
  //     ],
  //   );
  // }

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

  _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.sort, size: 34, color: Colors.black),
          Image.asset(
            "assets/images/aradhana.png",
            width: 35,
            height: 35,
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
            _buildSearch(),
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Agents",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildAgents(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  _buildAgents() {
    List<Widget> lists = List.generate(
      agents.length,
      (index) => AgentItem(
        data: agents[index],
      ),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: lists),
    );
  }
}
