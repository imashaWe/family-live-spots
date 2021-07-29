import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../edit_profile_view.dart';
import '/services/auth_service.dart';

class SocialConnectButtons extends StatefulWidget {
  final void Function(bool) onChangeLoading;
  final void Function(dynamic) onError;
  bool diable;
  SocialConnectButtons(
      {required this.diable,
      required this.onChangeLoading,
      required this.onError});
  @override
  State<StatefulWidget> createState() => _SocialConnectButtonsState();
}

class _SocialConnectButtonsState extends State<SocialConnectButtons> {
  void _signUpGoogel() {
    _setLoading(true);
    AuthService.googleSignUp().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView()),
            (route) => false).catchError((e) {
          widget.onError(e);
        }).whenComplete(() => _setLoading(false)));
  }

  void _signUpApple() {
    _setLoading(true);
    AuthService.appleSignUp().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView()),
            (route) => false).catchError((e) {
          widget.onError(e);
        }).whenComplete(() => _setLoading(false)));
  }

  void _signUpFacebook() {
    _setLoading(true);
    AuthService.facebookSignUp().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView()),
            (route) => false).catchError((e) {
          widget.onError(e);
        }).whenComplete(() => _setLoading(false)));
  }

  void _setLoading(bool v) {
    widget.diable = v;
    widget.onChangeLoading(v);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      SizedBox(
          width: w / 2.7,
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
              onPressed: () => widget.diable ? null : _signUpGoogel(),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.google),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Google")
                    ],
                  )))),
      SizedBox(
          width: w / 2.7,
          child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              onPressed: () => widget.diable ? null : _signUpFacebook(),
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.facebook),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Facebook")
                    ],
                  ))))
    ]);
  }
}
