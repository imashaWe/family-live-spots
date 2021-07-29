import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/auth/account/account.dart';
import 'package:family_live_spots/screens/auth/_auth_view.dart';
import 'package:family_live_spots/screens/auth/edit_profile_view.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/services/place_service.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  Future<UserProfile>? _future;
  @override
  void initState() {
    _future = AuthService.getProfile();
    super.initState();
  }

  void _logout() {
    AuthService.logout()
        .then((value) => Navigator.pushNamedAndRemoveUntil(
            context, '/auth', (route) => false))
        .catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    Widget optionCard({required String option, required Function onTap}) =>
        Card(
          child: ListTile(
            title: Text(option),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => onTap(),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        child: Column(
          children: [
            FutureBuilder<UserProfile>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  if (snapshot.hasError) {
                    if (snapshot.error == "not-logged-in")
                      return SizedBox(
                        height: 10,
                      );
                    return ErrorView();
                  }
                  return ListTile(
                      leading: ProfileImage(
                        size: 40,
                        userProfile: snapshot.data,
                      ),
                      title: Text(snapshot.data!.name),
                      subtitle: Text(snapshot.data!.email),
                      trailing: Icon(Icons.edit),
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Account())));
                }),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView(
              children: [
                optionCard(option: "Upgrade to premium", onTap: () => null),
                optionCard(option: "Support", onTap: () => null),
                optionCard(option: "Privacy policy", onTap: () => null),
                optionCard(option: "Log out", onTap: _logout),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
