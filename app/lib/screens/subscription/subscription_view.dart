import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/material.dart';

class SubscriptionView extends StatefulWidget {
  SubscriptionView({Key? key}) : super(key: key);

  @override
  _SubscriptionViewState createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          SizedBox(
            height: h / 4,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/intro.gif"))),
                  width: double.infinity,
                )),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                      color: Colors.grey,
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false),
                      icon: Icon(Icons.close)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: h / 10,
          ),
          Text(
            'Know Where Your\n Family is',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline4,
          ),
          Column(
              children: Constans.TRAIL_PACKAGE_LIST
                  .map((e) => ListTile(
                        leading: Icon(Icons.check),
                        title: Text(e),
                      ))
                  .toList()),
          Spacer(),
          SizedBox(
              width: w * .9,
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (route) => false),
                  child: Text(
                    "3 DAYS TRIAL",
                    style: TextStyle(fontSize: 18),
                  ))),
          TextButton(
              onPressed: () => {},
              child: Text(
                "Try Limited Version",
                style: TextStyle(fontSize: 16),
              )),
        ],
      )),
    );
  }
}
