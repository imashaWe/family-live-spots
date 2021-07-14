import 'package:family_live_spots/screens/widget/alert_message.dart';
import 'package:family_live_spots/screens/widget/custom_alert_dialog.dart';
import 'package:family_live_spots/screens/widget/or_divider.dart';
import 'package:family_live_spots/services/member_service.dart';
import 'package:flutter/material.dart';

class AddByPhone extends StatefulWidget {
  final bool isParent;
  AddByPhone({Key? key, required this.isParent}) : super(key: key);

  @override
  _MemberAddDialogState createState() => _MemberAddDialogState();
}

class _MemberAddDialogState extends State<AddByPhone> {
  final TextEditingController _phoneText = TextEditingController();
  bool _isLoading = false;
  void _add() {
    if (_phoneText.text.isEmpty) return;
    _setLoading(true);
    MemberService.addMember('lYKAV6gTdNPMSYDJVNYRG4or2Fv2', widget.isParent)
        .then((value) {
          AlertMessage.topSnackbarSuccess(
              message: 'You have been added a new family member!',
              context: context);
          Navigator.pop(context);
        })
        .catchError((e) => AlertMessage.topSnackbarError(
            message: 'Member not found or something went wrong!',
            context: context))
        .whenComplete(() => _setLoading(false));
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      icon: Icon(
        Icons.person_add,
        size: 40,
      ),
      childern: [
        TextField(
          controller: _phoneText,
          decoration: InputDecoration(labelText: "Code"),
        ),
        SizedBox(
          height: 10,
        ),
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(onPressed: _add, child: Text("Add")),
      ],
    );
  }
}
