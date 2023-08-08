import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var profile = "https://properties-api.myspacetech.in/aradhana.png";

List populars = [];

List recommended = [];

List recents = [];

List categories = [
  {
    "name": "All",
    "icon": FontAwesomeIcons.boxes,
    "color": Color.fromRGBO(185, 63, 70, 1.0)
  },
  {
    "name": "Apartment",
    "icon": FontAwesomeIcons.building,
    "color": Color.fromRGBO(1, 157, 166, 1.0)
  },
  {
    "name": "Bungalow",
    "icon": Icons.house_outlined,
    "color": Color.fromRGBO(239, 158, 64, 1.0)
  },
  {
    "name": "Mansion",
    "icon": FontAwesomeIcons.home,
    "color": Color.fromRGBO(32, 91, 171, 1.0)
  },
  {
    "name": "Villa",
    "icon": FontAwesomeIcons.university,
    "color": Color.fromRGBO(85, 103, 119, 1.0)
  },
];

List companies = [
  {
    "image":
        "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "on sale",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": false,
    "icon": Icons.domain_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1618221469555-7f3ad97540d6?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "on sold",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon": Icons.house_siding_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "on rent",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon": Icons.home_work_rounded
  },
];
