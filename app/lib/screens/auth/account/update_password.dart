import 'package:flutter/material.dart';
import '../../../screens/widget/alert_message.dart';
import '../../../services/auth_service.dart';

class UpdatePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _currentPassword;
  String? _newPassword;
  bool _isLoading = false;

  void _save() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _setLoading(true);
      AuthService.editPassword(
              currentPassword: _currentPassword!, newPassword: _newPassword!)
          .then((v) => Navigator.pushNamedAndRemoveUntil(
              context, '/settings', (route) => false))
          .catchError((e) {
        _formKey.currentState!.reset();
        AlertMessage.snakbarError(key: _scaffoldKey, message: e.toString());
      }).whenComplete(() => _setLoading(false));
    }
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            Expanded(
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: "Current Password:"),
                          onSaved: (v) => _currentPassword = v,
                          validator: (v) {
                            if (v!.isEmpty)
                              return 'Current password is requaired';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: 'New Password:'),
                          onSaved: (v) => _newPassword = v,
                          validator: (v) {
                            if (v!.isEmpty) return 'New password is requaired';
                            if (v.length < 6)
                              return 'Password should be at least 6 charecters';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: "Confirm_new_password:"),
                          validator: (v) {
                            if (v!.isEmpty) return 'Confirm new  is requaired';
                            if (v != _newPassword)
                              return "New password and confirm password doesn't match";
                            return null;
                          },
                        ),
                      ],
                    ))),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox(
                    width: double.infinity,
                    child:
                        ElevatedButton(onPressed: _save, child: Text("Save")),
                  )
          ],
        ),
      ),
    );
  }
}
