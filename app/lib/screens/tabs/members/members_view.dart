import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/member_service.dart';
import 'package:flutter/material.dart';
import 'add/member_add.dart';

class MembersView extends StatefulWidget {
  MembersView({Key? key}) : super(key: key);

  @override
  _MembersViewState createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  Future<List<UserProfile>>? _future;

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
                  print(snapshot.error);
                  return ErrorView();
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      final item = snapshot.data![i];
                      return Card(
                          child: ListTile(
                        leading: ProfileImage(size: 40, userProfile: item),
                        title: Text('Test'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Lorem Ipsum is dummy text used by designers and typographers to generate designs and test typefaces without real content. '),
                            Text(
                              'Today at 12.00 PM',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ));
                    });
              })),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => MemberAdd())),
        label: Text('Add'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
