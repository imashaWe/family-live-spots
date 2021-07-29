import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/services/location_service.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  HistoryView({Key? key}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  Future<List<UserLocation>>? _future;
  @override
  void initState() {
    _future = LocationService.getUserLocationHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: Container(
          child: FutureBuilder<List<UserLocation>>(
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
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      final item = snapshot.data![i];
                      return ListTile(
                        title: Text(item.dateTime.toString()),
                      );
                    });
              })),
    );
  }
}
