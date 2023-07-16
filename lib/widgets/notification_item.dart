import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'custom_image.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({Key? key, required this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(children: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CustomImage(
                    data["image"] ??
                        'https://properties-api.myspacetech.in/aradhana.png',
                    width: 60,
                    height: 60,
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
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          "8 mins ago",
                          softWrap: true,
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.new_releases,
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          )
        ]));
  }
}

void doNothing(BuildContext context) {}
