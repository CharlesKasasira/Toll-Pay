import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:tollpay/screens/operator/operator_dashboard.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool _loading = false;

  Future updateQRCode(String code) async {
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
      if (res.data['count'] == 0) {
        context.showErrorSnackBar(message: "This QR Code is already Expired");
      } else if (res.data['count'] == 1) {
        final response = await supabase
            .from('qrcodes')
            .update({'count': 0, 'status': 'Expired'})
            .eq('qrcode_id', code.split("\n")[0].trim())
            .execute();

        if (response.data != null) {
          context.showSuccessSnackBar(message: "successful");
        }
        return null;
      } else {
        final response = await supabase
            .from('qrcodes')
            .update({
              'count': (res.data['count'] as int) - 1,
            })
            .eq('qrcode_id', code.split("\n")[0].trim())
            .execute();

        if (response.data != null) {
          context.showSuccessSnackBar(message: "successful");
        }

        return null;
      }

      final error = res.error;
      if (error != null && res.status != 406) {
        // ignore: use_build_context_synchronously
        context.showErrorSnackBar(message: error.message);
      }

      return null;
    }

    setState(() {
      _loading = true;
    });
  }

  var getResult = 'Not yet scanned';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: ksecondary,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "QR Scanner",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            AppBarAvatar()
          ],
        ),
        leading: Builder(
          builder: (context) {
            return Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            );
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              "Scan QR code",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              getResult,
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 10,
            ),
            if (getResult == "Not yet scanned")
              Container(
                width: MediaQuery.of(context).size.width - 50,
                height: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: const Icon(
                  Icons.qr_code,
                  size: 150,
                ),
              ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Align the QR code with the frame to scan and confim ",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10.0,
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
