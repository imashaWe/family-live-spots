import 'package:flutter/material.dart';
import '../../../screens/widget/alert_message.dart';
import '../../../services/auth_service.dart';

class UpdateEmail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _email;
  String? _password;
  bool _isLoading = false;

  void _save() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _setLoading(true);
      AuthService.editEmail(email: _email!, password: _password!)
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
        title: Text("Change Email"),
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
                          decoration: InputDecoration(labelText: 'New Email:'),
                          initialValue: AuthService.user!.email,
                          onSaved: (v) => _email = v,
                          validator: (v) {
                            if (v!.isEmpty) return 'Email is requaired';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password:'),
                          onSaved: (v) => _password = v,
                          validator: (v) {
                            if (v!.isEmpty) return 'Password is requaired';
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
