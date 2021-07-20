import 'package:family_live_spots/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

class GiveAccessView extends StatelessWidget {
  const GiveAccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              child: SvgPicture.asset('assets/images/auth.svg'),
            ),
            SizedBox(
              height: 40,
            ),
            SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    LocationService.startTracking().then((value) =>
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (route) => false));
                  },
                  child: Text("Start")),
            ),
            Text('By start, I agree with \nterms of use and privacy policy.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
