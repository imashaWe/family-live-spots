import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/tabs/members/add/member_add.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/services/location_service.dart';
import 'package:family_live_spots/services/member_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_marker/cached_network_marker.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Future<List<UserProfile>>? _future;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};

  void _onTapUserProfile(UserProfile user) {
    if (user.lastLocation != null) {
      _focusLocation(user.lastLocation!.latLng);
    }
  }

  void _onMemberLocationListener(List<UserProfile> user) {
    _markers.clear();
    user.forEach((u) async {
      if (u.lastLocation != null) {
        final generator = CachedNetworkMarker(
          url: u.photoURL ?? ENV.DEFAULT_PHOTO_URL,
          dpr: MediaQuery.of(context).devicePixelRatio,
        );

        // generate bitmap
        final bitmap = await generator.circleAvatar(
            CircleAvatarParams(color: parseColorFromName(u.name)));

        setState(() => _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId(u.id),
            position: u.lastLocation!.latLng,
            infoWindow: InfoWindow(
              title: u.name,
              snippet: 'Last update ',
            ),
            icon: BitmapDescriptor.fromBytes(bitmap))));
      }
    });
  }

  void _focusLocation(LatLng loc) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition location = CameraPosition(
      target: loc,
      zoom: 14.4746,
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(location));
  }

  void _initMyLocation() {
    bg.BackgroundGeolocation.getCurrentPosition()
        .then((l) => _focusLocation(parseLatLngFromCoords(l.coords)));
    //   LocationService.syncMyCurrentLocation();
  }

  @override
  void initState() {
    _initMyLocation();
    _future = MemberService.fetchAllMembers();
    AuthService.getProfile().then((u) =>
        MemberService.membersSnapshot(u.members.map((e) => e.uid).toList())
            .listen(_onMemberLocationListener));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Family Live Spots"),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: _markers,
            mapType: MapType.normal,
            initialCameraPosition: ENV.INITIAL_LOCATION,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
                child: SizedBox(
              width: w * .9,
              height: h * .12,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: FutureBuilder<List<UserProfile>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return ErrorView();
                      }
                      return Row(
                        children: [
                          Expanded(
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, i) {
                                    final item = snapshot.data![i];

                                    return ProfileImage(
                                        size: h * .12 * .35,
                                        userProfile: item,
                                        onTap: () => _onTapUserProfile(item));
                                  })),
                          GestureDetector(
                              onTap: () {
                                LocationService.stopTracking();
                              },
                              // onTap: () => Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (_) => MemberAdd())),
                              child: CircleAvatar(
                                radius: h * .12 * .35,
                                child: Icon(Icons.add),
                              ))
                        ],
                      );
                    },
                  )),
            )),
          ),
        ],
      ),
    );
  }
}
