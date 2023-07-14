import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/pages/mprofile.dart';
import 'custom_image.dart';

class AgentItem extends StatelessWidget {
  const AgentItem({Key? key, required this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColor.shadowColor.withOpacity(0.1),
            spreadRadius: .5,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MProfilePage(id: data['id'])),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CustomImage(
                    data["image"] ??
                        'https://properties-api.myspacetech.in/aradhana.png',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    // Wrap the Column with Expanded
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["name"],
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "Agent",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Color.fromRGBO(245, 245, 245, 1),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Listed Properties: 2",
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Phone: " + data["phone"],
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Email: " + data["email"],
                          style: TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ]),
                ),
                const SizedBox(
                  width: 5,
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle button press
                        },
                        icon: Icon(
                          Icons.send,
                          size: 12,
                        ),
                        label: Text('Message',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColor.primary, // Set the button color to red
                        )),
                  ),
                ),
              ],
            ),
          ),
          /*const SizedBox(
            height: 10,
          ),
          _buildRate()*/
        ],
      ),
    );
  }

  Widget _buildRate() {
    return Row(
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: AppColor.yellow,
        ),
        Icon(
          Icons.star,
          size: 16,
          color: AppColor.yellow,
        ),
        Icon(
          Icons.star,
          size: 16,
          color: AppColor.yellow,
        ),
        Icon(
          Icons.star,
          size: 16,
          color: AppColor.yellow,
        ),
        Icon(
          Icons.star_outline,
          size: 16,
          color: AppColor.yellow,
        ),
      ],
    );
  }
}
