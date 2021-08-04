import 'package:family_live_spots/providers/user_provider.dart';
import 'package:family_live_spots/screens/subscription/subscription_view.dart';
import 'package:family_live_spots/services/auth_service.dart';
import '/screens/tab_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyUser extends StatelessWidget {
  const VerifyUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvide>(builder: (context, data, child) {
      if (data.isLoading)
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      if (!AuthService.isLoggedIn) return TabView();
      final subscription = data.profile!.subsription;
      if (data.profile!.subsription.isUseFreeTrial &&
          DateTime.now().difference(subscription.updatedAt).inDays <= 3)
        return TabView();
      if (data.profile!.subsription.isSubscribe) return TabView();
      return SubscriptionView();
    });
  }
}
