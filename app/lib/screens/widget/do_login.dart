import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoLogin extends StatelessWidget {
  const DoLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
              text: TextSpan(
                  text: "Please,",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  children: [
                TextSpan(
                    text: 'SIGN IN!',
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => Navigator.pushNamed(context, '/subscription'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold))
              ])),
          SizedBox(
            height: h / 4,
            child: SvgPicture.asset('assets/svgs/error.svg'),
          ),
        ],
      ),
    );
  }
}
