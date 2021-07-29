import 'package:family_live_spots/screens/auth/edit_profile_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'reset_password_dialog.dart';
import '../widget/alert_message.dart';
import 'widget/auth_button.dart';
import 'widget/auth_form_field.dart';
import 'widget/social_connect_buttons.dart';
import '../../../services/auth_service.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String? _email;
  String? _password;

  void _sumbit() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _setLoading(true);
      AuthService.signIn(email: _email!, password: _password!).then((v) =>
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => EditProfileView()),
              (route) => false).catchError((e) {
            _formKey.currentState!.reset();
            AlertMessage.snakbarError(key: _scaffoldKey, message: "Eroor");
          }).whenComplete(() => _setLoading(false)));
    }
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.only(top: h / 20, left: 10, right: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/subscription', (route) => false),
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
            Align(
              alignment: Alignment.topLeft,
              child: Text('Sign In,',
                  style: Theme.of(context).textTheme.headline4),
            ),
            _isLoading ? LinearProgressIndicator() : Divider(),
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                              height: h / 5,
                              child:
                                  SvgPicture.asset('assets/images/auth.svg')),
                          SizedBox(
                            height: 20,
                          ),
                          AuthFormField(
                            icon: Icons.email,
                            hintText: "Email",
                            onSaved: (v) => _email = v,
                            validator: (v) {
                              if (v!.isEmpty) return 'Email is requaired';
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          AuthFormField(
                            icon: Icons.lock,
                            obscureText: true,
                            hintText: "Password",
                            onSaved: (v) => _password = v,
                            validator: (v) {
                              if (v!.isEmpty) return 'Password is requaired';
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: RichText(
                              text: TextSpan(
                                  text: "Forgot password?",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ResetPasswordDialog()),
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: AuthButton(
                                disable: _isLoading,
                                onPressed: _sumbit,
                                text: "SIGN IN",
                              )),
                        ],
                      ))),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: RichText(
                  text: TextSpan(
                      text: "Don't have an account",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                    TextSpan(
                        text: '\tSIGN UP!',
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.pushNamed(context, '/sign-up'),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold))
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
