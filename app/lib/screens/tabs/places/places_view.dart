import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/widget/do_login.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'place_add.dart';

class PlacesView extends StatefulWidget {
  PlacesView({Key? key}) : super(key: key);

  @override
  _PlacesViewState createState() => _PlacesViewState();
}

class _PlacesViewState extends State<PlacesView> {
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
        title: Text("Places"),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<UserProfile>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.hasError) {
                  if (snapshot.error == "not-logged-in") return DoLogin();
                  print(snapshot.error);
                  return ErrorView();
                }
                return Column(
                  children: snapshot.data!.places
                      .map((e) => GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => PlaceAdd(e))),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Constans.primary_color
                                          .withOpacity(.08)),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: ListTile(
                                      leading: SizedBox(
                                          height: 40,
                                          child: Image.asset(e.iconPath)),
                                      title: Text("Add your ${e.title}"),
                                      trailing:
                                          Icon(Icons.arrow_forward_ios_sharp),
                                    ),
                                  )))))
                      .toList(),
                );
              })),
    );
  }
}
