import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/tabs/members/add/member_add.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/services/location_service.dart';
import 'package:family_live_spots/services/member_service.dart';
import 'package:family_live_spots/services/place_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:family_live_spots/utility/functions.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_marker/cached_network_marker.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:timeago/timeago.dart' as timeago;

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Future<List<UserProfile>>? _future;
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  void _onTapUserProfile(UserProfile user) {
    print(_markers.length);
    if (user.lastLocation != null) {
      _focusLocation(user.lastLocation!.latLng);
    }
  }

  void _onMemberLocationListener(List<UserProfile> user) {
    user.forEach((u) async {
      if (u.lastLocation != null) {
        final makerID = MarkerId(u.id);

        final generator = CachedNetworkMarker(
          url: u.photoURL ?? ENV.DEFAULT_PHOTO_URL,
          dpr: MediaQuery.of(context).devicePixelRatio,
        );

        final bitmap = await generator.circleAvatar(
            CircleAvatarParams(color: parseColorFromName(u.name)));

        setState(() {
          _markers.removeWhere((m) => m.markerId == makerID);
          _markers.add(Marker(
              markerId: makerID,
              position: u.lastLocation!.latLng,
              infoWindow: InfoWindow(
                title: u.name,
                snippet:
                    'Last update ${timeago.format(u.lastLocation!.dateTime)}',
              ),
              icon: BitmapDescriptor.fromBytes(bitmap)));
        });
      }
    });
  }

  void _initUserLoaction() {
    PlaceService.getUserPlacess().then((placess) {
      placess.forEach((p) => setState(() {
            BitmapDescriptor.fromAssetImage(
                    ImageConfiguration(size: Size(68, 68)),
                    'assets/images/makers/home.png')
                .then((icon) => _markers.add((Marker(
                    markerId: MarkerId(p.id),
                    position: p.latLng,
                    infoWindow: InfoWindow(
                      title: p.name,
                      snippet: p.address,
                    ),
                    icon: icon))));
            _circles.add(Circle(
                circleId: CircleId(p.id),
                center: p.latLng,
                radius: 5,
                fillColor: Colors.red));
          }));
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
  }

  @override
  void initState() {
    _initMyLocation();
    _initUserLoaction();
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
      body: SafeArea(
          child: Stack(
        children: [
          Positioned.fill(
              child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            markers: _markers,
            circles: _circles,
            mapType: MapType.normal,
            initialCameraPosition: ENV.INITIAL_LOCATION,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )),
          Align(
              alignment: Alignment.bottomCenter,
              child: FutureBuilder<List<UserProfile>>(
                future: _future,
                builder: (context, snapshot) {
                  final addButton = GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MemberAdd())),
                      child: CircleAvatar(
                        radius: h * .10 * .35,
                        child: Icon(Icons.add),
                      ));
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return ErrorView();
                  }
                  if (snapshot.data!.isEmpty) return addButton;
                  return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: SizedBox(
                          width: w * .9,
                          height: h * .10,
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Row(children: [
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, i) {
                                          final item = snapshot.data![i];

                                          return ProfileImage(
                                              size: h * .10 * .35,
                                              userProfile: item,
                                              onTap: () =>
                                                  _onTapUserProfile(item));
                                        })),
                                addButton
                              ]))));
                },
              )),
        ],
      )),
    );
  }
}
