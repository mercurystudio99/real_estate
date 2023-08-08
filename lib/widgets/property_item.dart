import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'package:real_estate/pages/property_details_screen.dart';
import 'package:real_estate/utils/globals.dart' as global;
import 'custom_image.dart';
import 'icon_box.dart';

class PropertyItem extends StatelessWidget {
  const PropertyItem({Key? key, required this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    bool isLike = false;
    List<String> likes = global.likes.split(',');
    likes.forEach((element) {
      if (element == data["id"].toString()) {
        isLike = true;
      }
    });

    return GestureDetector(
      onTap: () {
        navigateToDetailPage(context, data["id"].toString());
      },
      child: Container(
        width: double.infinity,
        height: 280,
        margin: EdgeInsets.fromLTRB(0, 0, 0, 1),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              spreadRadius: .5,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            CustomImage(
              data["image"],
              width: double.infinity,
              height: 150,
              radius: 10,
            ),
            Positioned(
              right: 20,
              top: 10,
              child: _buildFavorite(isLike),
            ),
            Positioned(
              right: 10,
              top: 160,
              child: _buildRating(),
            ),
            Positioned(
              left: 10,
              top: 160,
              child: _buildInfo(),
            ),
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

  Widget _buildFavorite(bool isLike) {
    return IconBox(
      child: Icon(
        isLike ? Icons.favorite : Icons.favorite_border,
        color: isLike ? AppColor.primary : Colors.white,
        size: 25,
      ),
    );
  }

  Widget _buildRating() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      IconBox(
        child: Icon(
          (data["review_score"] == null || data["review_score"] == '0.0')
              ? Icons.star_outline
              : Icons.star,
          size: 16,
          color: AppColor.yellow,
        ),
      ),
      Text(
        data["review_score"] ?? '0.0',
        style: TextStyle(fontSize: 16),
      )
    ]);
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data["name"],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Icon(
              Icons.place_outlined,
              color: AppColor.primary,
              size: 15,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              data["location"],
              style: TextStyle(fontSize: 15, color: AppColor.darker),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data["bed"].toString() +
              " Beds | " +
              data["bathroom"].toString() +
              " Baths | " +
              data["square"].toString() +
              " m sq",
          style: TextStyle(
            fontSize: 15,
            color: AppColor.darker,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data["price"] + " /mo",
          style: TextStyle(
            fontSize: 18,
            color: AppColor.darker,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
