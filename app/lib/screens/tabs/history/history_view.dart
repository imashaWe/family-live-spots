import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/tabs/history/user_history_view.dart';
import 'package:family_live_spots/screens/widget/do_login.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key? key}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  Future<UserProfile>? _future;
  @override
  void initState() {
    _future = AuthService.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("History"),
        ),
        body: Container(
          child: FutureBuilder<UserProfile>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.hasError) {
                  if (snapshot.error == "not-logged-in") return DoLogin();
                  return ErrorView();
                }
                return CarouselSlider(
                  options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: MediaQuery.of(context).size.height),
                  items: snapshot.data!.members
                      .map((e) => UserHistoryView(e.uid))
                      .toList(),
                );
              }),
        ));
  }
}
