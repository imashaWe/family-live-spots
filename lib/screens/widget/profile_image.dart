import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class ProfileImage extends StatelessWidget {
  final UserProfile? userProfile;
  final double size;
  final List<Color> _letterColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.limeAccent,
    Colors.pinkAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.indigoAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
    Colors.yellowAccent
  ];
  ProfileImage({this.userProfile, this.size = 20});

  @override
  Widget build(BuildContext context) {
    if (userProfile == null)
      return CircleAvatar(
        radius: size,
        child: Icon(
          Icons.person_add,
          size: size,
        ),
      );
    else {
      final l = userProfile!.name[0].toUpperCase();
      return userProfile!.photoURL == null
          ? CircleAvatar(
              backgroundColor: _letterColors[l.codeUnitAt(0) % 10],
              foregroundColor: Colors.black,
              radius: size,
              child: Text(
                l,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
              ))
          : CircleAvatar(
              radius: size,
              backgroundImage: NetworkImage(userProfile!.photoURL ?? ''),
            );
    }
  }
}
