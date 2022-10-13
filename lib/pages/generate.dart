import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase/supabase.dart';

import '../utils/constants.dart';

class GeneratePage extends StatefulWidget {
  var amount;
  var plate;
  var user;
  var username;

  String? phone;
  GeneratePage(
      {this.amount, this.phone, this.user, this.username, this.plate, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  Future<void> sendQRData() async {
    print("Hello world!");
    final response = await supabase.from('qrcodes').insert([
      {
        'user_id': widget.user.id,
        'qrcode_id': "QR${new DateTime.now()}",
        'count': 1,
        'status': 'Active',
        'amount': widget.amount,
        'username': widget.username,
        'plate_number': widget.plate
      }
    ]).execute();

    final error = response.error;
    if (error != null) {
      print(error.message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    sendQRData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String qrData = """
      QR${new DateTime.now()}
      Amount: ${widget.amount} 
      Name: ${widget.username}
      Plate Number: ${widget.plate}

      ----------------------------
      Active
    """;

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0x00000000),
        elevation: 0,
        foregroundColor: Colors.black,
        leading: Builder(
          builder: (context) {
            return Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            );
          },
        ),
        title: const Text("QR Code"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: QrImage(
                //plce where the QR Image will be shown
                embeddedImage: const AssetImage('assets/images/qr-icon.png'),
                data: qrData,
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Text(
              "* Your QR code is private, if you share it with someone, they can try to scan and use it.",
              style: TextStyle(fontSize: 15.0, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
}
