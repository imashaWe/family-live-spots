import 'package:family_live_spots/screens/widget/or_divider.dart';
import 'package:flutter/material.dart';

class MemberAddDialog extends StatefulWidget {
  MemberAddDialog({Key? key}) : super(key: key);

  @override
  _MemberAddDialogState createState() => _MemberAddDialogState();
}

class _MemberAddDialogState extends State<MemberAddDialog> {
  void _add() {}

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Dialog(
        child: Container(
            height: h / 3,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: "Member Id:"),
                  ),
                  ElevatedButton(onPressed: _add, child: Text("Join")),
                  ORDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                          onPressed: _add, child: Text("Create Family")),
                      OutlinedButton(
                          onPressed: _add, child: Text("Get member Id")),
                    ],
                  )
                ],
              ),
            )));
  }
}
