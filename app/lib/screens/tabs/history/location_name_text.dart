import 'package:family_live_spots/models/place.dart';
import 'package:family_live_spots/services/place_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geodesy/geodesy.dart' as geodesy;

class LocationNameText extends StatefulWidget {
  final LatLng location;
  final List<Place> userPlaces;
  LocationNameText({required this.location, required this.userPlaces, Key? key})
      : super(key: key);

  @override
  _LocationNameTextState createState() => _LocationNameTextState();
}

class _LocationNameTextState extends State<LocationNameText> {
  String _name = "Searching...";
// final Geodesy geodesy = Geodesy();
  void _setName() {
    final i = widget.userPlaces.indexWhere((e) => _isInplace(e));
    if (i != -1) {
      setState(() => _name = widget.userPlaces[i].title);
    } else {
      PlaceService.findPlaceByLatLong(widget.location)
          .then((value) => setState(() => _name = value))
          .catchError((e) => setState(() => _name = 'Unknow place'));
      ;
    }
  }

  bool _isInplace(Place p) {
    return geodesy.Geodesy().distanceBetweenTwoGeoPoints(
            geodesy.LatLng(widget.location.latitude, widget.location.longitude),
            geodesy.LatLng(p.location!.latitude, p.location!.longitude)) <
        ENV.MAX_DISTANCE_TWO_POINT;
  }

  @override
  void initState() {
    _setName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_name);
  }
}
