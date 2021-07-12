import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final IconData icon;
  final bool isRetryEnable;
  final void Function()? onRetry;

  ErrorView(
      {this.error = "Something went wrong",
      this.icon = Icons.warning_amber_outlined,
      this.isRetryEnable = false,
      this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            error,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      Visibility(
          visible: isRetryEnable,
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blueGrey.shade100),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                onRetry!();
              },
              child: Text('Retry')))
    ]));
  }
}
