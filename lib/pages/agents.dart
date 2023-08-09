import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/widgets/agent_items.dart';
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

  late TextEditingController? searchcontroller = TextEditingController();
  late String searchkeyword = '';

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
    List<Map<String, dynamic>> list = [];
    agents.forEach((element) {
      if (element['name'].contains(searchkeyword)) {
        list.add(element);
      }
    });

    if (list.isEmpty) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Center(child: const Text('No users')));
    } else {
      List<Widget> lists = List.generate(
        list.length,
        (index) => AgentItem(
          data: list[index],
        ),
      );

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(children: lists),
      );
    }
  }
}
