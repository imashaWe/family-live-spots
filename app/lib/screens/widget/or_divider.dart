import 'package:flutter/material.dart';

class ORDivider extends StatelessWidget {
  const ORDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Divider(
          thickness: 1,
        )),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5), child: Text("Or")),
        Expanded(
            child: Divider(
          thickness: 1,
        ))
      ],
    );
  }
}
