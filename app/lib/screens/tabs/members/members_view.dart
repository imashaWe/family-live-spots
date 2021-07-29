import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/widget/do_login.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/member_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/material.dart';
import 'add/member_add.dart';
import 'package:timeago/timeago.dart' as timeago;

class MembersView extends StatefulWidget {
  MembersView({Key? key}) : super(key: key);

  @override
  _MembersViewState createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  Future<List<UserProfile>>? _future;
  bool _isSignIn = false;

  @override
  void initState() {
    _future = MemberService.fetchAllMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("Members"),
        ),
        body: Container(
            padding: EdgeInsets.all(10),
            child: FutureBuilder<List<UserProfile>>(
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
                  _isSignIn = true;
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        final item = snapshot.data![i];
                        return GestureDetector(
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
                                          leading: ProfileImage(
                                              size: 30, userProfile: item),
                                          title: Text('Test'),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.lastLocation != null
                                                    ? "Last update ${timeago.format(item.lastLocation!.dateTime)}"
                                                    : 'Not update yet',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          ),
                                        )))));
                      });
                })),
        floatingActionButton: Visibility(
          visible: true,
          child: FloatingActionButton.extended(
            onPressed: () {
              if (!_isSignIn) return;
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MemberAdd()));
            },
            label: Text('Add'),
            icon: Icon(Icons.add),
          ),
        ));
  }
}
