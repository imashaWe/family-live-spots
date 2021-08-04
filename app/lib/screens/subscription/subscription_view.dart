import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/providers/user_provider.dart';
import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:family_live_spots/services/subsription_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../verfiy_user.dart';

class SubscriptionView extends StatefulWidget {
  SubscriptionView({Key? key}) : super(key: key);

  @override
  _SubscriptionViewState createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  bool _isLoading = false;

  void _tryLimitedVersion() {
    AlertMessage.topSnackbarError(
        message: 'Something went wrong', context: context);
    // SubsriptionService.buy(productDetails)()
    //     .then((value) => print(value))
    //     .catchError((e) => print(e));
  }

  void _restore() {
    _setLoading(true);
    SubsriptionService.restore()
        .then((value) => Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => VerifyUser()), (route) => false))
        .catchError((e) => AlertMessage.topSnackbarError(
            message: 'Something went wrong', context: context))
        .whenComplete(() => _setLoading(false));
  }

  void _getFreetrail() {
    _setLoading(true);
    SubsriptionService.setUpFreeTrail()
        .then((value) => Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => VerifyUser()), (route) => false))
        .catchError((e) => AlertMessage.topSnackbarError(
            message: 'Something went wrong', context: context))
        .whenComplete(() => _setLoading(false));
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final userProfile = Provider.of<UserProvide>(context, listen: false);
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          SizedBox(
            height: h / 2.5,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(Constans.INTRO_URL))),
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
          _isLoading
              ? CircularProgressIndicator()
              : Column(
                  children: [
                    Visibility(
                        visible: !userProfile.profile!.subsription.isSubscribe,
                        child: SizedBox(
                            width: w * .9,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(
                                        Constans.primary_color),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(vertical: 10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)))),
                                onPressed: _restore,
                                child: Text(
                                  "Restore",
                                  style: TextStyle(fontSize: 18),
                                )))),
                    Visibility(
                        visible:
                            !userProfile.profile!.subsription.isUseFreeTrial,
                        child: SizedBox(
                            width: w * .9,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(vertical: 10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)))),
                                onPressed: _getFreetrail,
                                child: Text(
                                  "3 DAYS TRIAL",
                                  style: TextStyle(fontSize: 18),
                                )))),
                    TextButton(
                        onPressed: _tryLimitedVersion,
                        child: Text(
                          "Try Limited Version",
                          style: TextStyle(fontSize: 16),
                        )),
                  ],
                )
        ],
      )),
    );
  }
}
