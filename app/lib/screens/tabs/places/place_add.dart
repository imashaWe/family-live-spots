import 'dart:async';

import 'package:family_live_spots/screens/tabs/places/place_search.dart';
import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:family_live_spots/services/place_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceAdd extends StatefulWidget {
  final String? name;
  PlaceAdd({Key? key, this.name}) : super(key: key);

  @override
  _PlaceAddState createState() => _PlaceAddState();
}

class _PlaceAddState extends State<PlaceAdd> {
  final GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final TextEditingController _nameText = TextEditingController();
  final TextEditingController _addressText = TextEditingController();

  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  String? _id;
  String? _name;
  String? _address;

  bool _isLoading = false;

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
    if (_frmKey.currentState!.validate()) {
      if (_markers.isEmpty) {
        AlertMessage.snakbarError(
            message: 'Please select the location!', key: _key);
        return;
      }
      _setLoading(true);
      if (_id == null) {
        PlaceService.addNewPlace(
                name: _name!,
                address: _address!,
                location: parseGeoPoint(_markers.first.position),
                isOtherPlace: _name == null)
            .then((value) => Navigator.pushNamedAndRemoveUntil(
                context, '/places', (route) => false))
            .whenComplete(() => _setLoading(false))
            .catchError((e) =>
                AlertMessage.snakbarError(message: e.toString(), key: _key));
      } else {
        PlaceService.updatePlace(
          id: _id!,
          name: _name!,
          address: _address!,
          location: parseGeoPoint(_markers.first.position),
        )
            .then((value) => Navigator.pushNamedAndRemoveUntil(
                context, '/places', (route) => false))
            .whenComplete(() => _setLoading(false))
            .catchError((e) =>
                AlertMessage.snakbarError(message: e.toString(), key: _key));
      }
    }
  }

  void _focusLocation(LatLng loc) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition location = CameraPosition(
      target: loc,
      zoom: 14.4746,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(location));
  }

  void _findMyLocation() {
    bg.BackgroundGeolocation.getCurrentPosition().then((l) {
      l.timestamp;
      final loc = LatLng(l.coords.latitude, l.coords.longitude);
      _focusLocation(loc);
      _onTapLocation(loc);
    });
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);

  @override
  void initState() {
    if (widget.name != null) _name = widget.name;
    super.initState();

    PlaceService.getPlaceByName(name: widget.name).then((r) {
      setState(() {
        _id = r.id;
        _addressText.text = r.address;
        _nameText.text = r.name;
        _focusLocation(parseLatLng(r.location));
        _onTapLocation(parseLatLng(r.location));
      });
    }).catchError((e) {
      print(e);
    });
  }

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
                onTap: () => onTap(),
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
      key: _key,
      appBar: AppBar(
        title: Text("Add ${widget.name ?? 'place'}"),
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
                  Visibility(
                      visible: widget.name == null,
                      child: TextFormField(
                        controller: _nameText,
                        onSaved: (v) => _name = v,
                        decoration: InputDecoration(labelText: "Name:"),
                        validator: (v) {
                          if (v!.isEmpty) return "Name is required!";
                          return null;
                        },
                      )),
                  TextFormField(
                      controller: _addressText,
                      onSaved: (v) => _address = v,
                      decoration: InputDecoration(labelText: "Address:"),
                      validator: (v) {
                        if (v!.isEmpty) return "Address is required!";
                        return null;
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Location:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      height: h / 2,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: GoogleMap(
                              markers: _markers,
                              mapType: MapType.normal,
                              initialCameraPosition: ENV.INITIAL_LOCATION,
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
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton(onPressed: _save, child: Text("Save")))
          ],
        ),
      ),
    );
  }
}
