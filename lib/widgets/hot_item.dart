import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/pages/property_details_screen.dart';

import 'custom_image.dart';

class HotItem extends StatelessWidget {
  const HotItem({Key? key, required this.data}) : super(key: key);
  final data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToDetailPage(context, data["id"].toString());
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            CustomImage(
              data["image"],
              radius: 10,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: _buildInfo(),
            )
          ],
        ),
      ),
    );
  }

  void navigateToDetailPage(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(propertyId: id),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hot",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data["name"],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.place_outlined,
              color: Colors.grey,
              size: 13,
            ),
            const SizedBox(
              width: 3,
            ),
            Expanded(
              child: Text(
                data["location"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.bed,
              color: AppColor.primary,
            ),
            SizedBox(width: 5),
            Text(data["days_since"], style: TextStyle(fontSize: 12)),
            SizedBox(width: 10),
            Icon(
              Icons.bathtub,
              color: AppColor.primary,
            ),
            SizedBox(width: 5),
            Text(data["days_since"], style: TextStyle(fontSize: 12)),
            Spacer(),
            Text(data["price"], style: TextStyle(fontSize: 12)),
            Text("/m", style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(width: 10)
          ],
        ),
      ],
    );
  }
}
