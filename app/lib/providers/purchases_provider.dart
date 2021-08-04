import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class DashPurchases extends ChangeNotifier {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final _iap = InAppPurchase.instance;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
