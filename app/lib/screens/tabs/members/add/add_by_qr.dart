import 'dart:typed_data';

import 'package:family_live_spots/services/auth_service.dart';
import 'package:flutter/material.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
//import 'package:permission_handler/permission_handler.dart';

class AddByQR extends StatefulWidget {
  final Function(String)? onScan;
  AddByQR({this.onScan});

  @override
  State<StatefulWidget> createState() => _QrViewState();
}

class _QrViewState extends State<AddByQR> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  Uint8List? _myqr;
  bool _isLoading = false;
  @override
  void initState() {
    _makeMyCode();
    super.initState();
  }

  void _makeMyCode() async {
    // // Generating QR-Code
    // _myqr = await scanner.generateBarCode(AuthService.user!.uid);
    setState(() {});
  }

  void _scan() async {
    //   if (!await _requestPermisson()) return;
    //  // String id = await scanner.scan();
    //   if (id.isEmpty) return;
    //   widget.onScan!(id);
  }

  Future<bool> _requestPermisson() async {
    return true;
    // var status = await Permission.camera.status;
    // if (status.isDenied) {
    //   status = await Permission.camera.request();
    // }
    // return status.isGranted;
  }

  void _setLoading(bool v) => setState(() => _isLoading = v);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("QR Code"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Add member by scanning their QR Code',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 40,
            ),
            _myqr == null
                ? CircularProgressIndicator()
                : SizedBox(
                    height: h / 4,
                    child: Image.memory(_myqr!),
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  indent: w / 6,
                )),
                Text('Or'),
                Expanded(
                    child: Divider(
                  endIndent: w / 6,
                )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            _isLoading
                ? CircularProgressIndicator()
                : TextButton(onPressed: _scan, child: Text("Scan")),
          ],
        ),
      ),
    );
  }
}
