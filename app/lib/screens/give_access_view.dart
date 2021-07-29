import 'package:family_live_spots/services/location_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

import 'widget/error_view.dart';

class GiveAccessView extends StatefulWidget {
  GiveAccessView({Key? key}) : super(key: key);

  @override
  _GiveAccessViewState createState() => _GiveAccessViewState();
}

class _GiveAccessViewState extends State<GiveAccessView> {
  bool _isLoading = false;
  bool _isLocServiceEnable = true;
  bool _isBackGrounServiceEnable = true;
  bool _isPhysicalEnable = true;

  void _requirestAccess() {
    LocationService.requestPermisson().then((value) =>
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false));
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close)),
            ),
            Text(
              "Family Live Spots requires these\n permissions to work correclty",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: h / 8,
            ),
            // FutureBuilder<bg.ProviderChangeEvent>(
            //     future: LocationService.state,
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting)
            //         return Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       if (snapshot.hasError) {
            //         return ErrorView();
            //       }
            //       return Column(
            //         children: [

            //         ],
            //       );

            // }),

            SwitchListTile(
                title: Text(
                  "Location",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                subtitle: Text(
                    "Required to share your location with members of your circle"),
                value: _isLocServiceEnable,
                onChanged: (v) => setState(() => _isLocServiceEnable = v)),
            SwitchListTile(
                title: Text(
                  "Background location",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                subtitle: Text(
                    "Family Live Spots collects location data even when the app is closed or not in to provide your location history to yo and to memebrs of your circle."),
                value: _isBackGrounServiceEnable,
                onChanged: (v) =>
                    setState(() => _isBackGrounServiceEnable = v)),
            SwitchListTile(
                title: Text(
                  "Physical activity",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                subtitle: Text(
                    "Required to provide more reliable location while improving battery life"),
                value: _isPhysicalEnable,
                onChanged: (v) => setState(() => _isPhysicalEnable = v)),

            SizedBox(
              height: h / 6,
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                    onPressed: _isBackGrounServiceEnable &
                            _isPhysicalEnable &
                            _isLocServiceEnable
                        ? _requirestAccess
                        : null,
                    child: Text(
                      "Sure, I'd like that",
                      style: TextStyle(fontSize: 18),
                    )),
            TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (route) => false),
                child: Text(
                  "Not now",
                  style: TextStyle(fontSize: 16),
                )),
          ],
        ),
      ),
    );
  }
}
