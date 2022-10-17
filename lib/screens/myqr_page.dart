import 'dart:convert';

// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/screens/qr_details.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';

class MyQRCodes extends StatefulWidget {
  const MyQRCodes({Key? key}) : super(key: key);

  @override
  _MyQRCodesState createState() => _MyQRCodesState();
}

class _MyQRCodesState extends AuthRequiredState<MyQRCodes> {
  String? _userId;
  String? _avatarUrl;
  String? firstName;
  String? lastName;
  String? username;
  var activeQrCodes;

  Future getActiveQRCodes() async {
    final response = await supabase.from('qrcodes').select().order('created_at', ascending: false).execute();

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
    // getActiveQRCodes();
  }

  @override
  Widget build(BuildContext context) {
    print(activeQrCodes);
    getActiveQRCodes();
    return Scaffold(
      backgroundColor: ColorConstants.kprimary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: const Color(0xff1a1a1a),
        elevation: 1,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "My QR Codes",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 10,
            ),
            AppBarAvatar()
          ],
        ),
        leading: Builder(builder: (context) {
          return Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        }),
      ),
      body: SafeArea(
        minimum: EdgeInsets.only(top: 30),
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
  // @override
  // Widget build(BuildContext context) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: (location as List<dynamic>).length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.qr_code),
            trailing: Text(
              "${location[index]['status']}",
              style: TextStyle(color: location[index]['status'] == 'Active' ? Colors.green : Colors.red, fontSize: 15),
            ),
            title: Text(
              "${location[index]['amount']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${Jiffy(location[index]['created_at']).yMMMMd}"),
            onTap: () {
              Get.off(
                () => QRDetails(id: location[index]['id']),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              );
            },
          ),
        );
      });
  // }
}

