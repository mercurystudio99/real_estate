import 'package:flutter/material.dart';
import 'package:real_estate/theme/color.dart';
import 'custom_image.dart';
import 'package:real_estate/pages/property_details_screen.dart';

class SpotLightItem extends StatelessWidget {
  const SpotLightItem({Key? key, required this.data}) : super(key: key);

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
              navigateToDetailPage(context, data["id"].toString());
            },
            child: Container(
              width: double.infinity,
              height: 200,
              child: Stack(
                children: [
                  CustomImage(
                    data["image"],
                    width: double.infinity,
                    height: 200,
                    radius: 10,
                  ),
                  Positioned(
                    right: 10,
                    top: 160,
                    child: _buildPrice(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                // Wrap the Column with Expanded
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["name"],
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      data["address"] ?? '',
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      data["location"] ?? '',
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.home,
                          color: AppColor.primary,
                          size: 25.0,
                        ),
                        Text(
                          data["rooms"].toString(),
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff777676)),
                        ),
                        Icon(
                          Icons.bed,
                          color: AppColor.primary,
                          size: 24,
                        ),
                        Text(
                          data["bed"].toString(),
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff777676)),
                        ),
                        Icon(
                          Icons.bathtub,
                          color: AppColor.primary,
                          size: 24,
                        ),
                        Text(
                          data["bathroom"].toString(),
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff777676)),
                        ),
                        Icon(
                          Icons.square_foot,
                          color: AppColor.primary,
                          size: 25.0,
                        ),
                        Text(
                          data["square"].toString() + " m sq",
                          style:
                              TextStyle(fontSize: 15, color: Color(0xff777676)),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          /* const SizedBox(
            height: 10,
          ),
          Text(
            data["description"],
            style: TextStyle(height: 1.5, color: AppColor.darker),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildRate()*/
        ],
      ),
    );
  }

  Widget _buildPrice() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(
        decoration: BoxDecoration(
          color: AppColor.primary, // Replace with your desired background color
          borderRadius: BorderRadius.circular(
              5.0), // Replace with your desired border radius value
        ),
        padding: EdgeInsets.all(4.0),
        child: Text(
          data["price"] + " /m",
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.cardColor,
          ),
        ),
      )
    ]);
  }

  void navigateToDetailPage(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsScreen(propertyId: id),
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
