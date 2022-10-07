import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase/supabase.dart';

import '../utils/constants.dart';

class GeneratePage extends StatefulWidget {
  var amount;
  var user;

  String? phone;
  GeneratePage({this.amount, this.phone, this.user, Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
// already generated qr code when the page opens
  String? firstName;
  String? lastName;
  bool _loading = false;

//get users Profile
  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    firstName = (data['first_name'] ?? '') as String;
    lastName = (data['last_name'] ?? '') as String;

    setState(() {
      _loading = false;
    });
  }

  @override
  void onAuthenticated(Session session) {
    
  }

  @override
  Widget build(BuildContext context) {
    print(firstName);
    String qrData = "${widget.amount}, ${firstName}, ${lastName}";
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
            // Padding(
            //   padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
            //   child: TextButton(
            //     // padding: EdgeInsets.all(15.0),
            //     onPressed: () async {
            //       if (qrdataFeed.text.isEmpty) {
            //         //a little validation for the textfield
            //         setState(() {
            //           qrData = "";
            //         });
            //       } else {
            //         setState(() {
            //           qrData = qrdataFeed.text;
            //         });
            //       }
            //     },
            //     child: Text(
            //       "Generate QR",
            //       style: TextStyle(
            //           color: Colors.blue, fontWeight: FontWeight.bold),
            //     ),
            //     // shape: RoundedRectangleBorder(
            //     //     side: BorderSide(color: Colors.blue, width: 3.0),
            //     //     borderRadius: BorderRadius.circular(20.0)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  final qrdataFeed = TextEditingController();
}
