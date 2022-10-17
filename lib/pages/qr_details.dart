// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';

class QRDetails extends StatefulWidget {
  var id;
  QRDetails({Key? key, this.id}) : super(key: key);

  @override
  _QRDetailsState createState() => _QRDetailsState();
}

class _QRDetailsState extends AuthRequiredState<QRDetails> {
  String? _userId;
  String? _avatarUrl;
  String? firstName;
  String? lastName;
  String? username;
  var activeQrCodes;

  Future getActiveQRCodes() async {
    final response =
        await supabase.from('qrcodes').select().eq('id', widget.id).execute();

    final data = response.data;
    final error = response.error;

    // print("inside");
    if (data != null) {
      // print(data);
      activeQrCodes = data.length;
    } else {
      activeQrCodes = "There is no data";
    }

    if (error != null) {
      print("the error is ${error.message}");
    }
    return data;
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    // _user = user;
    if (user != null) {
      _userId = user.id;
      getActiveQRCodes();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getActiveQRCodes();
    return Scaffold(
      backgroundColor: ColorConstants.kprimary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: ksecondary,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "QR Details",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 10,
            ),
            AppBarAvatar()
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Get.off(
            //   () => const OrganisationHomePage(),
            //   transition: Transition.cupertino,
            //   duration: const Duration(milliseconds: 600),
            //   curve: Curves.easeOut,
            // );
          },
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 8.0,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),
            children: [
              FutureBuilder(
                  future: getActiveQRCodes(),
                  builder: (context, snapshot) {
                    print("This is ${snapshot.data}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff1a1a1a),
                          ),
                        );
                      default:
                        return snapshot.data == null
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Icon(Icons.wifi_off_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Check your internet connection.",
                                        style: TextStyle(
                                            fontFamily: "Spartan",
                                            color:
                                                Color.fromARGB(255, 24, 24, 24),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : QRList(snapshot.data);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget QRList(location) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: QrImage(
          //plce where the QR Image will be shown
          embeddedImage: const AssetImage('assets/images/qr-icon.png'),
          data: """
                  ${location[0]['qrcode_id']}
                  Amount: ${location[0]['amount']} 
                  Name: ${location[0]['username']}
                  Plate Number: ${location[0]['plate_number']}

                  ----------------------------
                  status: ${location[0]['status']}
                """,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      ListTile(
        leading: const Icon(Icons.qr_code),
        title: Text(
          "${location[0]['amount']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${Jiffy(location[0]['created_at']).yMMMMd}"),
      ),
    ],
  );
  // }
}
// "${location[0]['created_at']}

Widget getLocationScreen(location) {
  Map<String, IconData> descList = {
    'Clouds': Icons.cloud_outlined,
    'Rain': FontAwesomeIcons.cloudRain,
    'Snow': FontAwesomeIcons.snowflake,
    'Drizzle': FontAwesomeIcons.cloudShowersHeavy,
    'Clear': FontAwesomeIcons.cloudShowersHeavy,
  };

  return Container(
    height: 180,
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    // width: MediaQuery.of().size.width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "http://openweathermap.org/img/wn/${location.icon}@2x.png",
            ),
            Text(
              "${location.description}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${location.temp}",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: ColorConstants.ksecondary,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "ENTEBBE",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Uganda",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 62, 62, 62),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
