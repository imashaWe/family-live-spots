import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widget/custom_alert_dialog.dart';
import '../../services/auth_service.dart';

class ResetPasswordDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResetPasswordDialog();
}

class _ResetPasswordDialog extends State<ResetPasswordDialog> {
  final TextEditingController _emailText = TextEditingController();

  bool _isLoading = false;
  bool _isSend = false;
  String? _erorr;

  void _send() {
    if (_emailText.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _erorr = null;
    });

    AuthService.forgotPassword(email: _emailText.text)
        .then((r) => setState(() => _isSend = true))
        .catchError((e) => setState(() => _erorr = e))
        .whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: !_isSend
                ? CustomAlertDialog(
                    icon: Icon(
                      FontAwesomeIcons.lock,
                      size: 30,
                    ),
                    childern: [
                      Container(
                        child: Text(
                          'Reset password',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Enter the email associated with your account and we'll send an email with instruction to reset your password",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _emailText,
                        autofocus: true,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email), labelText: 'Email'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _erorr != null,
                        child: ListTile(
                          leading: Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          title: Text(
                            _erorr ?? '',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                child: Text(
                                  "Send Instruction",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                onPressed: _send,
                              ))
                    ],
                  )
                : CustomAlertDialog(
                    icon: Icon(
                      Icons.check,
                      size: 30,
                    ),
                    childern: [
                      Container(
                        child: Text(
                          'Check your mail',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        child: Text(
                          "We have sent a password recover instructions to your email.",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            child: Text(
                              "Ok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ))
                    ],
                  )));
  }
}
