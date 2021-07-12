import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class VerifyOTPView extends StatefulWidget {
  final void Function(String) onSubmit;
  final void Function() onResend;

  final bool isLoading;

  VerifyOTPView(
      {Key? key,
      required this.onSubmit,
      required this.onResend,
      required this.isLoading})
      : super(key: key);
  @override
  _VerifyOTPViewState createState() => _VerifyOTPViewState();
}

class _VerifyOTPViewState extends State<VerifyOTPView> {
  String _pin = "";

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: h / 8,
          ),
          Text(
            "Enter OTP",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: h / 15,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: OTPTextField(
                length: 6,
                width: w * .8,
                fieldWidth: 30,
                style: TextStyle(fontSize: 17),
                // textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.underline,
                onCompleted: (pin) => _pin = pin),
          )),
          widget.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  child: Text("Verify"),
                  onPressed: () => widget.onSubmit(_pin),
                ),
          Visibility(
              visible: !widget.isLoading,
              child: TextButton(
                  onPressed: widget.onResend, child: Text("Resend"))),
          Visibility(
              visible: !widget.isLoading,
              child: Text(
                  'By logging in, I agree with \nterms of use and privacy policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey)))
        ],
      ),
    );
  }
}
