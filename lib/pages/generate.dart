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
      {this.amount,
      this.phone,
      this.user,
      this.username,
      this.plate,
      Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
// already generated qr code when the page opens

  @override
  Widget build(BuildContext context) {
    String qrData = """
      Amount: ${widget.amount} 
      First Name: ${widget.username}
      Plate Number: ${widget.plate}
      Paid
    """;
    int count = 0;
    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        elevation: 0,
        foregroundColor: Colors.black,
        leading: Builder(builder: (context) {
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
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        }),
        title: const Text("QR Code"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: QrImage(
                //plce where the QR Image will be shown
                embeddedImage: AssetImage('assets/images/qr-icon.png'),
                data: qrData,
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Text(
              "* Your QR code is private, if you share it with someone, they can try to scan and use it.",
              style: TextStyle(fontSize: 15.0),
            ),
          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
}
