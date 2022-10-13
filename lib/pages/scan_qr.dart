import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:tollpay/pages/operator/operator_dashboard.dart';
import 'package:tollpay/utils/constants.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _loading = false;

  void _moveBack() {
    Get.off(
      () => const OperatorHomePage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  Future<void> updateQRCode(String code) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('qrcodes')
        .update({'count': 0, 'status': 'Expired'})
        .eq('qrcode_id', code.split("\n")[0].trim())
        .execute();

    final error = response.error;
    if (error != null && response.status != 406) {
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      context.showSuccessSnackBar(message: "successful");
    }
  }

  var getResult = 'Not yet scanned';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("QR Scanner"),
        foregroundColor: Colors.black,
        elevation: 3,
        leading: Builder(builder: (context) {
          return Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Get.back();
              },
            ),
          );
        }),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                getResult,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () async {
                scanQRCode();
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(),
                ),
                child: const Text(
                  "Open Scanner",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (!mounted) return;

      setState(() {
        getResult = qrCode;
        updateQRCode(qrCode);
      });

      if (getResult != 'Not yet scanned') {
        updateQRCode(qrCode);
      }
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }
  }
}
