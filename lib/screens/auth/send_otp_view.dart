import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SendOTPView extends StatefulWidget {
  final void Function(String) onSubmit;
  final bool isLoading;
  SendOTPView({Key? key, required this.onSubmit, required this.isLoading})
      : super(key: key);

  @override
  _SendOTPViewState createState() => _SendOTPViewState();
}

class _SendOTPViewState extends State<SendOTPView> {
  String _phone = '';

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: h / 8,
          ),
          Text(
            "Enter your mobile number \nto receive an OTP",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: h / 15,
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: InternationalPhoneNumberInput(
            initialValue: PhoneNumber(isoCode: "LK"),
            //  countries: ['LK'],
            onInputChanged: (v) {
              _phone = v.phoneNumber.toString();
            },

            onSubmit: () => widget.onSubmit(_phone),
          ))),
          widget.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  child: Text("GET OTP"),
                  onPressed: () => widget.onSubmit(_phone),
                )
        ],
      ),
    );
  }
}
