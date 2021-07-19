import 'package:family_live_spots/screens/auth/edit_profile_view.dart';
import 'package:family_live_spots/screens/auth/verify_otp_view.dart';
import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'send_otp_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthView extends StatefulWidget {
  AuthView({Key? key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool _isSendState = false;
  bool _isLoading = false;
  String? _verificationId;
  int? _resendToken;

  void _onTapSendOTP(String phone) async {
    if (phone.isEmpty) {
      _setError('Invalid phone number');
      return;
    }
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) {
      _setProcessing(true);
      _auth.signInWithCredential(phoneAuthCredential).then((u) async {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => EditProfileView()),
            (route) => false);
      }).catchError((e) {
        _setError(e.code);
      }).whenComplete(() => _setProcessing(false));
    };

    final PhoneCodeSent codeSent = (String? verificationId, int? resendToken) {
      _verificationId = verificationId;
      _resendToken = resendToken;
      _setProcessing(false);
      setState(() {
        _isSendState = true;
      });
    };

    PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException e) {
      _setError(e.code);
      _setProcessing(false);
    };

    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout =
        (String verificationId) {};

    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        //phoneNumber: '+16505556789',
        verificationCompleted: verificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  void _onTapVerifyOTP(String pin) {
    if (pin.isEmpty) {
      _setError('Invalid code');
      return;
    }
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: pin);
    _auth.signInWithCredential(phoneAuthCredential).then((u) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => EditProfileView()),
          (route) => false);
    }).catchError((e) {
      _setError(e.code);
    }).whenComplete(() => _setProcessing(false));
  }

  void _setError(String e) => AlertMessage.snakbarError(message: e, key: _key);
  void _setProcessing(bool v) => setState(() => _isLoading = v);
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(children: [
          SizedBox(
            height: h / 10,
          ),
          SizedBox(
            height: h / 4,
            child: SvgPicture.asset('assets/images/auth.svg'),
          ),
          SizedBox(
              height: h / 2,
              child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _isSendState
                      ? VerifyOTPView(
                          isLoading: _isLoading,
                          onResend: () {},
                          onSubmit: _onTapVerifyOTP,
                        )
                      : SendOTPView(
                          isLoading: _isLoading,
                          onSubmit: _onTapSendOTP,
                        )))
        ]),
      ),
    );
  }
}
