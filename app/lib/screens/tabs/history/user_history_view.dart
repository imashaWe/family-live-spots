import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/tabs/history/location_name_text.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/location_service.dart';
import 'package:family_live_spots/services/member_service.dart';
import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserHistoryView extends StatefulWidget {
  final String uid;
  UserHistoryView(this.uid);

  @override
  _UserHistoryViewState createState() => _UserHistoryViewState();
}

class _UserHistoryViewState extends State<UserHistoryView> {
  Future<List<UserLocation>>? _userLocationFuture;
  Future<UserProfile>? _memberFuture;
  int _index = 0;

  @override
  void initState() {
    _memberFuture = MemberService.getMemberById(widget.uid);
    _userLocationFuture =
        LocationService.getUserLocationHistoryByUid(widget.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: FutureBuilder<UserProfile>(
          future: _memberFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: Text("Loading...."),
              );
            if (snapshot.hasError) {
              print(snapshot.error);
              return ErrorView();
            }
            final userPlaces =
                snapshot.data!.places.where((e) => e.location != null).toList();
            return Column(
              children: [
                ListTile(
                  leading: ProfileImage(
                    userProfile: snapshot.data,
                  ),
                  title: Text(snapshot.data!.name),
                  subtitle: Text(snapshot.data!.lastLocation == null
                      ? "Not update yet"
                      : "Last update ${timeago.format(snapshot.data!.lastLocation!.dateTime)}"),
                ),
                Expanded(
                  child: FutureBuilder<List<UserLocation>>(
                      future: _userLocationFuture,
                      builder: (context2, snapshot2) {
                        if (snapshot2.connectionState ==
                            ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        if (snapshot2.hasError) {
                          print(snapshot2.error);
                          return ErrorView();
                        }
                        if (snapshot2.data!.isEmpty)
                          ErrorView(
                            error: "No records available",
                          );
                        return Timeline.tileBuilder(
                          builder: TimelineTileBuilder.fromStyle(
                            contentsAlign: ContentsAlign.alternating,
                            contentsBuilder: (context2, index) {
                              final item = snapshot2.data![index];
                              return Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      LocationNameText(
                                          location: item.latLng,
                                          userPlaces: userPlaces),
                                      Text(
                                        timeago.format(item.dateTime),
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ]),
                              );
                            },
                            itemCount: snapshot2.data!.length,
                          ),
                        );
                      }),
                )
              ],
            );
          }),
    );
  }
}
