import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'member_add_dialog.dart';

class MemberAdd extends StatelessWidget {
  const MemberAdd({Key? key}) : super(key: key);

  void _onTap(context) {
    showDialog(context: context, builder: (_) => MemberAddDialog());
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    Widget memberTypeCard(
            {required String image,
            required String title,
            required String subtitle,
            required Function onTap}) =>
        Card(
          elevation: 5,
          child: GestureDetector(
              onTap: () => onTap(),
              child: SizedBox(
                  height: h / 6,
                  width: w * .8,
                  child: Row(
                    children: [
                      SizedBox(width: w / 3, child: SvgPicture.asset(image)),
                      Expanded(
                          child: Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                subtitle,
                                textAlign: TextAlign.start,
                              )),
                        ],
                      ))
                    ],
                  ))),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Member"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(children: [
          memberTypeCard(
              image: 'assets/images/child.svg',
              title: 'Child',
              subtitle:
                  "You'll be a parenet for this conatct who can't invisible without your permisson",
              onTap: () => _onTap(context)),
          memberTypeCard(
              image: 'assets/images/parent.svg',
              title: 'Parent',
              subtitle:
                  "You can't be invisible from your parents without this permission",
              onTap: () => _onTap(context)),
          memberTypeCard(
              image: 'assets/images/invite-code.svg',
              title: 'Invitation Code',
              subtitle: "Enter your invitation code here.",
              onTap: () => _onTap(context)),
        ]),
      ),
    );
  }
}
