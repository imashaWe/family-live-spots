import 'dart:async';

import 'package:family_live_spots/screens/tabs/places/place_search.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceAdd extends StatefulWidget {
  PlaceAdd({Key? key}) : super(key: key);

  @override
  _PlaceAddState createState() => _PlaceAddState();
}

class _PlaceAddState extends State<PlaceAdd> {
  final GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String? _name;
  String? _address;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _onTapLocation(LatLng loc) {
    setState(() {
      _markers = {};
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(loc.toString()),
        position: loc,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _save() {
    _frmKey.currentState!.save();
    if (_frmKey.currentState!.validate()) {}
  }

  void _findMyLocation() {}
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    Widget mapIconButton(
            {required IconData icon,
            required foregroundColor,
            required Function onTap}) =>
        Padding(
            padding: EdgeInsets.all(5),
            child: GestureDetector(
                onTap: () => onTap,
                child: CircleAvatar(
                  radius: 20,
                  foregroundColor: foregroundColor,
                  backgroundColor: Colors.white,
                  child: Icon(
                    icon,
                    size: 20,
                  ),
                )));
    return Scaffold(
      appBar: AppBar(
        title: Text("Add place"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                child: Form(
              key: _frmKey,
              child: ListView(
                children: [
                  TextFormField(
                    onSaved: (v) => _name = v,
                    decoration: InputDecoration(labelText: "Name:"),
                    validator: (v) {
                      if (v!.isEmpty) return "Name is required!";
                      return null;
                    },
                  ),
                  TextFormField(
                      onSaved: (v) => _address = v,
                      decoration: InputDecoration(labelText: "Address:"),
                      validator: (v) {
                        if (v!.isEmpty) return "Address is required!";
                        return null;
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                      height: h / 2,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: GoogleMap(
                              markers: _markers,
                              mapType: MapType.normal,
                              initialCameraPosition: _kGooglePlex,
                              onTap: _onTapLocation,
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          ),
                          Positioned(
                              top: 10,
                              right: 5,
                              child: mapIconButton(
                                foregroundColor: Colors.blue,
                                icon: Icons.search,
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => PlaceSearch())),
                              )),
                          Positioned(
                              top: 60,
                              right: 5,
                              child: mapIconButton(
                                  foregroundColor: Colors.green,
                                  icon: Icons.my_location,
                                  onTap: _findMyLocation))
                        ],
                      )),
                ],
              ),
            )),
            ElevatedButton(onPressed: _save, child: Text("Add place"))
          ],
        ),
      ),
    );
  }
}
