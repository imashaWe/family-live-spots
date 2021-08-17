import 'package:family_live_spots/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestPermissionModal extends StatefulWidget {
  RequestPermissionModal({Key? key}) : super(key: key);

  @override
  _RequestPermissionModalState createState() => _RequestPermissionModalState();
}

class _RequestPermissionModalState extends State<RequestPermissionModal> {
  void _requestPermission() {
    Navigator.of(context).pop();
    LocationService.permisson.requestPermisson();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Family Live Spots requires following\npermissions to work correclty:",
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline6,
          ),
          ListTile(
            leading: Icon(Icons.my_location_sharp),
            title: Text('Location'),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.locationArrow),
            title: Text('Background location'),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.running),
            title: Text('Physical activity'),
          ),
          SizedBox(
            child: ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
                onPressed: _requestPermission,
                child: Text(
                  "Give Permission",
                  style: TextStyle(fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
