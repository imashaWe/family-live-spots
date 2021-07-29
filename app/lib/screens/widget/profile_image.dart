import 'package:family_live_spots/utility/functions.dart';
import 'package:flutter/material.dart';
import '../../models/user_profile.dart';

class ProfileImage extends StatelessWidget {
  final UserProfile? userProfile;
  final Function? onTap;
  final double size;

  ProfileImage({this.userProfile, this.size = 20, this.onTap});

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

      return GestureDetector(
          onTap: () => onTap!(),
          child: userProfile!.photoURL == null
              ? CircleAvatar(
                  backgroundColor: parseColorFromName(userProfile!.name),
                  foregroundColor: Colors.black,
                  radius: size,
                  child: Text(
                    l,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: size),
                  ))
              : CircleAvatar(
                  radius: size,
                  backgroundColor: parseColorFromName(userProfile!.name),
                  child: CircleAvatar(
                    radius: size - 5,
                    backgroundImage: NetworkImage(userProfile!.photoURL ?? ''),
                  )));
    }
  }
}
