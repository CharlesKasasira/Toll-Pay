import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        title: Text("QR Scanner"),
        foregroundColor: Colors.black,
        elevation: 0,
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
                onPressed: () => Navigator.of(context).popUntil((_) => count++ >= 2),
              ),
            );
          }),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              // padding: EdgeInsets.all(15.0),
              onPressed: () async {
                String codeSanner =
                    (await BarcodeScanner.scan()) as String; //barcode scnner
                setState(() {
                  qrCodeResult = codeSanner;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.black),
                ),
                child: const Text(
                  "Open Scanner",
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class ScanPage extends StatefulWidget {
//   @override
//   _ScanPageState createState() => _ScanPageState();
// }

// class _ScanPageState extends State<ScanPage> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("anything happening");
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 5,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: (result != null)
//                   ? Text(
//                       'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   : Text('Scan a code'),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

// //   String qrCodeResult = "Not Yet Scanned";
// //   int count = 0;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xfff5f5f5),
// //       appBar: AppBar(
// //         backgroundColor: Color(0x00000000),
// //         title: Text("QR Scanner"),
// //         foregroundColor: Colors.black,
// //         elevation: 0,
// //         leading: Builder(builder: (context) {
// //             return Container(
// //               width: 25,
// //               height: 25,
// //               margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
// //               decoration: BoxDecoration(
// //                   boxShadow: [
// //                     BoxShadow(
// //                       color: Colors.grey.withOpacity(0.2),
// //                       spreadRadius: 2,
// //                       blurRadius: 3,
// //                       offset: Offset(0, 3), // changes position of shadow
// //                     ),
// //                   ],
// //                   color: Colors.white,
// //                   borderRadius: BorderRadius.all(Radius.circular(25))),
// //               child: new IconButton(
// //                 icon: new Icon(Icons.arrow_back, color: Colors.black),
// //                 onPressed: () => Navigator.of(context).popUntil((_) => count++ >= 2),
// //               ),
// //             );
// //           }),
// //       ),
// //       body: Container(
// //         padding: EdgeInsets.all(20.0),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: <Widget>[
// //             Text(
// //               "Result",
// //               style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
// //               textAlign: TextAlign.center,
// //             ),
// //             Text(
// //               qrCodeResult,
// //               style: TextStyle(
// //                 fontSize: 20.0,
// //               ),
// //               textAlign: TextAlign.center,
// //             ),
// //             SizedBox(
// //               height: 20.0,
// //             ),
// //             TextButton(
// //               // padding: EdgeInsets.all(15.0),
// //               onPressed: () async {
// //                 String codeSanner =
// //                     (await BarcodeScanner.scan()) as String; //barcode scnner
// //                 setState(() {
// //                   qrCodeResult = codeSanner;
// //                 });
// //               },
// //               child: Container(
// //                 padding: const EdgeInsets.all(15),
// //                 decoration: BoxDecoration(
// //                   borderRadius: BorderRadius.circular(15.0),
// //                   border: Border.all(color: Colors.black),
// //                 ),
// //                 child: const Text(
// //                   "Open Scanner",
// //                   style:
// //                       TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
