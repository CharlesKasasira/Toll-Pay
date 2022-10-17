import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';

class GeneratePage extends StatefulWidget {
  var amount;
  var plate;
  var user;
  var username;
  String? count;

  String? phone;
  GeneratePage(
      {this.amount,
      this.phone,
      this.user,
      this.username,
      this.plate,
      this.count,
      Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  String? _avatarUrl;
  Future<void> sendQRData() async {
    final response = await supabase.from('qrcodes').insert([
      {
        'user_id': widget.user.id,
        'qrcode_id': "QR${new DateTime.now()}",
        'count': widget.count,
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
    String qrData = """ QR${new DateTime.now()} \n Amount: ${widget.amount} \n Name: ${widget.username} \n Plate Number: ${widget.plate} \n ----------------------------\n Active
    """;

    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: const Color(0xff1a1a1a),
        elevation: 0,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) {
            return Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Get.off(
                    () => const OrganisationHomePage(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                },
              ),
            );
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Generate Token",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 10,
            ),
            AppBarAvatar()
          ],
        ),
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
