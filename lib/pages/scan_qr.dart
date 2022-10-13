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
  String? _avatarUrl;

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

    final res = await supabase
        .from('qrcodes')
        .select('count')
        .eq('qrcode_id', code.split("\n")[0].trim())
        .single()
        .execute();

    if (res.data != null) {
      if (res.data == 0) {
        context.showErrorSnackBar(message: "This QR Code is already Expired");
      } else if (res.data == 1) {
        final response = await supabase
            .from('qrcodes')
            .update({'count': 0, 'status': 'Expired'})
            .eq('qrcode_id', code.split("\n")[0].trim())
            .execute();
      } else {
        final response = await supabase
            .from('qrcodes')
            .update({'count': res.data - 1, 'status': 'Active'})
            .eq('qrcode_id', code.split("\n")[0].trim())
            .execute();
      }

      final error = res.error;
      if (error != null && res.status != 406) {
        // ignore: use_build_context_synchronously
        context.showErrorSnackBar(message: error.message);
      }
      final data = res.data;
      if (data != null) {
        context.showSuccessSnackBar(message: "successful");
      }
    }

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
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: Color(0xff1a1a1a),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "QR Scanner",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 10,
            ),
            if (_avatarUrl == null || _avatarUrl!.isEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(75.0),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.bottomCenter,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 200, 200, 200),
                  ),
                  child: Image.asset("assets/images/avatar_icon.png"),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(75.0),
                child: Image.network(
                  _avatarUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
        leading: Builder(builder: (context) {
          return Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.off(
                    () => const OperatorHomePage(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
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
    } on PlatformException {
      getResult = 'Failed to scan QR Code.';
    }
  }
}
