import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
    required this.data,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  final data;
  final bool selected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
        padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: <Widget>[
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColor.primary
                        : Colors.grey, // Set the border color here
                    width: 2.0, // Set the border width if needed
                  ) // Replace with your desired circle color
                  ),
              child: Icon(
                data["icon"],
                color: selected ? AppColor.primary : data["color"],
                size: 30.0,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(data["name"],
                style: TextStyle(fontSize: 15, color: AppColor.darker)),
          ],
        ),
      ),
    );
  }
}
