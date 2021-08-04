import 'package:flutter/material.dart';

class Constans {
  static final primary_color = Color(0xFFBE0C6F);
  static final INTRO_TEXT = "See your family's location on the map";
  static final TRAIL_PACKAGE_LIST = [
    "Add up to 10 memebers",
    "Get full movement history",
    "2 month history",
    "Real time members location",
  ];

  static final INTRO_URL =
      "https://firebasestorage.googleapis.com/v0/b/filtersmusic-d259d.appspot.com/o/intro.gif?alt=media&token=bf558de7-22ee-44c4-89dc-2a71ed58e62d";
  static final T_AND_C_LINK =
      "https://sites.google.com/view/familylivespotsterms/home";
  static final PRIVACY_POLICE_LINK =
      "https://sites.google.com/view/family-live-spots/home";
  static final USER_LOCATIONS = [
    {
      'id': 0,
      'title': 'home',
      'name': 'home',
      'address': null,
      'location': null,
      'iconPath': 'assets/makers/home.png'
    },
    {
      'id': 1,
      'title': 'school',
      'name': 'school',
      'address': null,
      'location': null,
      'iconPath': 'assets/makers/school.png'
    },
    {
      'id': 2,
      'title': 'office',
      'name': 'office',
      'address': null,
      'location': null,
      'iconPath': 'assets/makers/office.png'
    },
    {
      'id': 3,
      'title': 'other',
      'name': null,
      'address': null,
      'location': null,
      'iconPath': 'assets/makers/placeholder.png'
    },
  ];
  static final subsription = {
    'isSubscribe': false,
    'isUseFreeTrial': false,
    'updatedAt': DateTime.now(),
    'maxMembers': 0,
    'maxHistoryMonth': 0
  };
}
