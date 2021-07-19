import 'package:flutter/material.dart';

class MemberAddOption extends StatefulWidget {
  final String name;
  MemberAddOption({Key? key, required this.name}) : super(key: key);

  @override
  _MemberAddOptionState createState() => _MemberAddOptionState();
}

class _MemberAddOptionState extends State<MemberAddOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.name}'),
      ),
      body: Container(),
    );
  }
}
