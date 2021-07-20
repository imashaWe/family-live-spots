import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/models/user_profile.dart';
import 'update_name.dart';
import 'update_profile.dart';
import '/screens/widget/error_view.dart';
import '/screens/widget/profile_image.dart';
import '/services/auth_service.dart';
import 'update_email.dart';
import 'update_password.dart';

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          child: FutureBuilder<UserProfile>(
              future: AuthService.getProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return ErrorView();
                }
                return Column(
                  children: [
                    GestureDetector(
                        child: ProfileImage(
                          userProfile: snapshot.data,
                          size: 50,
                        ),
                        onTap: () => Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => UpdateProfile(
                                        snapshot.data!,
                                      )),
                            )),
                    ListTile(
                      //leading: Icon(Icons.email),
                      title: Text("Name"),
                      trailing: Text(snapshot.data!.name),
                      onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => UpdateName(
                                    name: snapshot.data!.name,
                                  ))),
                    ),
                    Divider(),
                    ListTile(
                      //leading: Icon(Icons.email),
                      title: Text("Email"),
                      trailing: Text(snapshot.data!.email),
                      onTap: () => Navigator.push(context,
                          CupertinoPageRoute(builder: (_) => UpdateEmail())),
                    ),
                    Divider(),
                    ListTile(
                      //leading: Icon(Icons.lock),
                      title: Text("Password"),
                      //trailing: Icon(Icons.lock),
                      onTap: () => Navigator.push(context,
                          CupertinoPageRoute(builder: (_) => UpdatePassword())),
                    ),
                    Divider(),
                  ],
                );
              })),
    );
  }
}
