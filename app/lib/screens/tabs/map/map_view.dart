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
import 'package:flutter/gestures.dart';
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
  StreamSubscription<List<UserProfile>>? _listener;

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
    AuthService.getProfile()
        .then((pro) => pro.places.forEach((p) {
              if (p.location != null) {
                setState(() {
                  BitmapDescriptor.fromAssetImage(
                          ImageConfiguration(size: Size(68, 68)), p.iconPath)
                      .then((icon) => _markers.add((Marker(
                          markerId: MarkerId(p.id.toString()),
                          position: p.latLng,
                          infoWindow: InfoWindow(
                            title: p.name,
                            snippet: p.address,
                          ),
                          icon: icon))));
                  // _circles.add(Circle(
                  //     circleId: CircleId(p.id.toString()),
                  //     center: p.latLng,
                  //     radius: 60,
                  //     fillColor: Colors.red.withOpacity(.9)));
                });
              }
            }))
        .catchError((e) {
      print(e);
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

  void _onLocation(bg.Location location) {
    _focusLocation(parseLatLngFromCoords(location.coords));
  }

  void _onLocationError(bg.LocationError error) {
    print('[${bg.Event.LOCATION}] ERROR - $error');
  }

  void _initLocationServices() {
    LocationService.state.then((s) {
      if (!s.enabled) {
        Navigator.pushNamed(context, '/give-access');
      } else {
        LocationService.startTracking();
        LocationService.onLocationChange(_onLocation, _onLocationError);
      }
    });
  }

  @override
  void initState() {
    if (!mounted) return;
    _initLocationServices();
    _initUserLoaction();
    _future = MemberService.fetchAllMembers(onlyChild: true);
    AuthService.getProfile().then((u) {
      final members = u.members
          .where((e) => e.isParent == false)
          .map((e) => e.uid)
          .toList();
      if (members.isNotEmpty) {
        _listener = MemberService.membersSnapshot(members)
            .listen(_onMemberLocationListener);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _listener?.cancel();
    super.dispose();
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
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.hasError) {
                    if (snapshot.error == "not-logged-in")
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.warning),
                          title: RichText(
                              text: TextSpan(
                                  text: "Please,",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  children: [
                                TextSpan(
                                    text: 'SIGN IN!',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, '/give-access'),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold))
                              ])),
                        ),
                      );
                    return ErrorView();
                  }
                  if (snapshot.data!.isEmpty)
                    return SizedBox(
                        width: w * .4,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 10)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)))),
                            onPressed: () => Navigator.push(context,
                                MaterialPageRoute(builder: (_) => MemberAdd())),
                            child: Text("Add Members")));
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
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, i) {
                                          final item = snapshot.data![i];

                                          return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: ProfileImage(
                                                  size: h * .10 * .35,
                                                  userProfile: item,
                                                  onTap: () =>
                                                      _onTapUserProfile(item)));
                                        })),
                                GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => MemberAdd())),
                                    child: CircleAvatar(
                                      radius: h * .10 * .35,
                                      child: Icon(Icons.add),
                                    ))
                              ]))));
                },
              )),
        ],
      )),
    );
  }
}
