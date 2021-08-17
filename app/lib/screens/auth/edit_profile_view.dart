import 'dart:io';

import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/screens/tab_view.dart';
import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:family_live_spots/screens/widget/profile_image.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  EditProfileView();

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _frmKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController _nameText = TextEditingController();
  final _picker = ImagePicker();

  PickedFile? _pickedFile;
  String? _name;
  bool _isLoading = false;

  UserProfile? _profile;

  void _save() {
    _frmKey.currentState!.save();
    if (_frmKey.currentState!.validate()) {
      _setLoading(true);
      if (_profile != null) {
        AuthService.updateteProfile(
                name: _name!,
                imagePath: _pickedFile == null ? null : _pickedFile!.path)
            .then((value) => Navigator.pushNamedAndRemoveUntil(
                context, '/subscription', (route) => false))
            .catchError((e) =>
                AlertMessage.snakbarError(message: e.toString(), key: _key))
            .whenComplete(() => _setLoading(false));
      } else {
        AuthService.createProfile(
                name: _name!,
                imagePath: _pickedFile == null ? null : _pickedFile!.path)
            .then((value) => Navigator.pushNamedAndRemoveUntil(
                context, '/subscription', (route) => false))
            .catchError((e) =>
                AlertMessage.snakbarError(message: e.toString(), key: _key))
            .whenComplete(() => _setLoading(false));
      }
    }
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);

  @override
  void initState() {
    AuthService.getProfile()
        .then((p) => setState(() {
              _profile = p;
              _nameText.text = p.name;
            }))
        .catchError((e) => print(e));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                SizedBox(
                  height: h / 6,
                ),
                GestureDetector(
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (_) => Container(
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height / 5,
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Profile Photo",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          _pickedFile = await _picker.getImage(
                                              source: ImageSource.gallery);
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.greenAccent,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.photo),
                                            ),
                                            Text("Gallery")
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          _pickedFile = await _picker.getImage(
                                              source: ImageSource.camera);
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  Colors.blueAccent,
                                              foregroundColor: Colors.white,
                                              child: Icon(Icons.camera),
                                            ),
                                            Text("Camera")
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),
                    child: _pickedFile == null
                        ? ProfileImage(size: 40, userProfile: _profile)
                        : CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(File(_pickedFile!.path)),
                          )),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: Form(
                        key: _frmKey,
                        child: SingleChildScrollView(
                          child: TextFormField(
                            controller: _nameText,
                            decoration: InputDecoration(labelText: "Name"),
                            onSaved: (v) => _name = v,
                            validator: (v) {
                              if (v!.isEmpty) return "Name is required!";
                              return null;
                            },
                          ),
                        ))),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: _save, child: Text("Save")))
              ],
            ),
          ),
        ));
  }
}
