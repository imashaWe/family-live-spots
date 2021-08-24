import 'package:family_live_spots/models/user_profile.dart';
import 'package:family_live_spots/providers/user_provider.dart';
import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:family_live_spots/screens/widget/error_view.dart';
import 'package:family_live_spots/services/subsription_service.dart';
import 'package:family_live_spots/utility/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../verfiy_user.dart';

class SubscriptionView extends StatefulWidget {
  SubscriptionView({Key? key}) : super(key: key);

  @override
  _SubscriptionViewState createState() => _SubscriptionViewState();
}

class _SubscriptionViewState extends State<SubscriptionView> {
  bool _isLoading = false;
  Future<List<ProductDetails>>? _future;

  void _purchasePackage(ProductDetails product) {
    SubsriptionService.buy(product)
        .then((value) => print("Succees"))
        .catchError((e) => AlertMessage.topSnackbarError(
            message: 'Something went wrong', context: context));
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
  void initState() {
    _future = SubsriptionService.getPlanes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final userProfile = Provider.of<UserProvide>(context, listen: true);

    return Scaffold(
      body: Container(
          child: Column(
        children: [
          SizedBox(
            height: h / 2.7,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/intro.gif'))),
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
            style: Theme.of(context).textTheme.headline5,
          ),
          Column(
              children: Constans.TRAIL_PACKAGE_LIST
                  .map(
                    (e) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.check),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              e,
                              style: Theme.of(context).textTheme.subtitle1,
                            )
                          ],
                        )),
                  )
                  .toList()),
          Spacer(),
          FutureBuilder<List<ProductDetails>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    _isLoading ||
                    userProfile.profile == null)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.hasError) {
                  return ErrorView();
                }
                final package = snapshot.data![0];
                return Column(
                  children: [
                    SizedBox(
                        width: w * .9,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 7)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)))),
                            onPressed:
                                userProfile.profile!.subsription.isUseFreeTrial
                                    ? null
                                    : _getFreetrail,
                            child: Text(
                              "3 DAYS TRIAL",
                              style: TextStyle(fontSize: 18),
                            ))),
                    TextButton(
                        onPressed: () => _purchasePackage(package),
                        child: Text(
                          "Try Limited Version",
                          style: TextStyle(fontSize: 16),
                        )),
                    RichText(
                        text: TextSpan(
                            text: "I have already subscribe,",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                          TextSpan(
                              text: '\tRestore',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _restore(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold))
                        ])),
                  ],
                );
              }),
        ],
      )),
    );
  }
}
