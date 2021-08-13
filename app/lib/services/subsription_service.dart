import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_live_spots/services/auth_service.dart';
import 'package:family_live_spots/utility/env.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubsriptionService {
  static final _iap = InAppPurchase.instance;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> buy(ProductDetails productDetails) async {
    try {
      final r = await _iap.buyNonConsumable(
          purchaseParam: PurchaseParam(
              productDetails: productDetails,
              applicationUserName: AuthService.user!.uid));
      if (r) {
        _firestore.collection('User').doc(AuthService.user!.uid).update({
          'subscription': {
            'isSubscribe': true,
            'isUseFreeTrial': true,
            'updatedAt': DateTime.now(),
            'maxMembers': 10,
            'maxHistoryMonth': 2
          }
        });
      }
    } catch (e) {
      throw e;
    }
  }

  static Future<void> restore() async {
    try {
      _iap.restorePurchases(applicationUserName: AuthService.user!.uid);
    } on InAppPurchaseException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<ProductDetails>> getPlanes() async {
    try {
      final r = await _iap.queryProductDetails({ENV.SUBSCRIPTION_PLAN_NAME});
      return r.productDetails;
    } catch (e) {
      throw e;
    }
  }

  static Future<void> setUpFreeTrail() async {
    try {
      _firestore.collection('User').doc(AuthService.user!.uid).update({
        'subscription': {
          'isSubscribe': false,
          'isUseFreeTrial': true,
          'updatedAt': DateTime.now(),
          'maxMembers': 10,
          'maxHistoryMonth': 2
        }
      });
    } catch (e) {
      throw e;
    }
  }
}
