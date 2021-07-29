import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomImagePicker extends StatelessWidget {
  final _picker = ImagePicker();
  void Function(String path) onSubmit;

  PickedFile? _pickedFile;

  BottomImagePicker({required this.onSubmit});
  void _submit() {
    if (_pickedFile != null) {
      onSubmit(_pickedFile!.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  _pickedFile =
                      await _picker.getImage(source: ImageSource.gallery);
                  _submit();
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
                  _pickedFile =
                      await _picker.getImage(source: ImageSource.camera);
                  _submit();
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
    );
  }
}
