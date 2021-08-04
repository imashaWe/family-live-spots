import 'dart:ui';

import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_profile_view.dart';

class AuthView extends StatefulWidget {
  AuthView({Key? key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  void _setLoading(bool v) => setState(() => _isLoading = v);
  void _signWithGoogle() {
    _setLoading(true);
    AuthService.googleSignUp().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView()),
            (route) => false)
        .catchError((e) => AlertMessage.snakbarError(
            message: "Something went wrong", key: _key))
        .whenComplete(() => _setLoading(false)));
  }

  void _signWithFacebook() {
    _setLoading(true);
    AuthService.facebookSignUp().then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView()),
            (route) => false)
        .catchError((e) => AlertMessage.snakbarError(
            message: "Something went wrong", key: _key))
        .whenComplete(() => _setLoading(false)));
  }

  void _launchURL(url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final border =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.pushNamedAndRemoveUntil(
                        context, '/home', (route) => false),
                child: SizedBox(
                    width: w / 3.8,
                    child: Row(
                      children: [
                        Text("Skip for later"),
                        Icon(Icons.arrow_right_alt)
                      ],
                    )),
              ),
            ),
            _isLoading ? LinearProgressIndicator() : Divider(),
            SizedBox(
              height: h / 4,
              child: SvgPicture.asset('assets/images/auth.svg'),
            ),
            SizedBox(
              height: h / 10,
            ),
            Text(
              "Continue with",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 10)),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        shape: MaterialStateProperty.all(border)),
                    onPressed: _isLoading ? null : _signWithGoogle,
                    icon: Icon(FontAwesomeIcons.google),
                    label: Text("GOOGLE"))),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 10)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(border)),
                    onPressed: _isLoading ? null : _signWithFacebook,
                    icon: Icon(FontAwesomeIcons.facebook),
                    label: Text("FACEBOOK"))),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 10)),
                        shape: MaterialStateProperty.all(border)),
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushNamed(context, '/sign-in'),
                    icon: Icon(FontAwesomeIcons.envelope),
                    label: Text("EMAIL"))),
            SizedBox(
              height: h / 10,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "By Creating an account I agree with\n",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(
                          text: 'Terms of use',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchURL(Constans.T_AND_C_LINK),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: ' and '),
                      TextSpan(
                          text: 'Privacy policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => _launchURL(Constans.PRIVACY_POLICE_LINK),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold))
                    ])),
          ],
        ),
      ),
    );
  }
}
