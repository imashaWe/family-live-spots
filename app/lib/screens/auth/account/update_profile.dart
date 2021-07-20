import 'dart:io';

import 'package:flutter/material.dart';
import '/models/user_profile.dart';
import '/screens/widget/alert_message.dart';
import '/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  final UserProfile profile;
  UpdateProfile(this.profile);
  @override
  State<StatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  PickedFile? _pickedFile;
  bool _isLoading = false;
  void _save() {
    if (_pickedFile == null) return;
    _setLoading(true);
    AuthService.updateProfile(_pickedFile!.path)
        .then((value) => Navigator.pushNamedAndRemoveUntil(
            context, '/settings', (route) => false))
        .catchError(
            (e) => AlertMessage.snakbarError(key: _key, message: e.toString()))
        .whenComplete(() => _setLoading(false));
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);

  @override
  Widget build(BuildContext context) {
    void _showChangeProfile() => showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Photo",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              backgroundColor: Colors.greenAccent,
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
                              backgroundColor: Colors.blueAccent,
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
            ));

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Change Profile"),
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              GestureDetector(
                  onTap: _showChangeProfile,
                  child: _pickedFile == null
                      ? CircleAvatar(radius: 80, child: Icon(Icons.add_a_photo))
                      : CircleAvatar(
                          radius: 80,
                          backgroundImage: FileImage(File(_pickedFile!.path)),
                        )),
              Spacer(),
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
          )),
    );
  }
}
