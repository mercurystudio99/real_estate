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

var brokers = [
  {
    "image":
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MjV8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "John Siphron",
    "address": "Porte de Vanves",
    "location": "Miami",
    "bed": 4,
    "bathroom": 1,
    "square": 250,
    "price": "3900.00",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Corey Aminoff",
    "address": "Porte de Vanves",
    "location": "Miami",
    "bed": 3,
    "bathroom": 1,
    "square": 250,
    "price": "3900.00",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1617069470302-9b5592c80f66?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Siriya Aminoff",
    "address": "Porte de Vanves",
    "location": "Miami",
    "bed": 3,
    "bathroom": 1,
    "square": 250,
    "price": "3900.00",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Rubin Joe",
    "address": "Porte de Vanves",
    "location": "Miami",
    "bed": 3,
    "bathroom": 1,
    "square": 250,
    "price": "3900.00",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
];

List companies = [
  {
    "image":
        "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "TS Home",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": false,
    "icon": Icons.domain_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1618221469555-7f3ad97540d6?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Century 21",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon": Icons.house_siding_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Dabest Pro",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon": Icons.home_work_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Cam Reality",
    "location": "Phnom Penh, Cambodia",
    "type": "Broker",
    "is_favorited": true,
    "icon": Icons.location_city_rounded
  },
];
