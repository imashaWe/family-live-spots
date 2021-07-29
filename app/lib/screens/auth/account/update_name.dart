import 'package:flutter/material.dart';
import '../../../screens/widget/alert_message.dart';
import '../../../services/auth_service.dart';

class UpdateName extends StatefulWidget {
  final String name;
  final bool isInitTime;
  UpdateName({required this.name, this.isInitTime = false});
  @override
  State<StatefulWidget> createState() => _UpdateNameSatate();
}

class _UpdateNameSatate extends State<UpdateName> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _name;
  bool _isLoading = false;

  void _save() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      _setLoading(true);
      AuthService.editName(newName: _name!)
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
        title: Text("Change Name"),
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
                          decoration: InputDecoration(labelText: "New name:"),
                          initialValue: widget.name,
                          onSaved: (v) => _name = v,
                          validator: (v) {
                            if (v!.isEmpty) return 'Name is requaired';
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
