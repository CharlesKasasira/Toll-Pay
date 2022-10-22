import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/screens/organisation/drivers/add_driver.dart';
import 'package:tollpay/screens/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/utils/get_drivers.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';
import 'package:tollpay/widgets/drivers_list.dart';
import 'package:tollpay/widgets/empty_widget.dart';

class OrganisationReport extends StatefulWidget {
  var user;

  OrganisationReport({
    Key? key,
  }) : super(key: key);

  @override
  State<OrganisationReport> createState() => _OrganisationReportState();
}

class _OrganisationReportState extends State<OrganisationReport> {
  String? _avatarUrl;
  bool isAndroid = false;
  var operators;
  var usedQRCodes;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getQRcodes() async {
    final response = await supabase
        .from('qrcodes')
        .select()
        .eq("user_id", supabase.auth.user()!.id)
        .execute();

    final data = response.data;
    final error = response.error;

    if (data != null) {
      print(data);
      if (operators == null) {
        setState(() {
          operators = data;
        });
      }
    } else {}

    if (error != null) {
      print("the error is ${error.message}");
    }

    final res = await supabase
        .from('qrcodes')
        .select()
        .eq("user_id", supabase.auth.user()!.id)
        .eq("status", "Expired")
        .execute();

    final result = res.data;
    final err = res.error;

    if (result != null) {
      if (usedQRCodes == null) {
        setState(() {
          usedQRCodes = result;
        });
      }
    } else {}

    return data;
  }

  @override
  Widget build(BuildContext context) {
    getQRcodes();
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
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
                "Report",
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
                onPressed: () {
                  Get.back();
                },
              ),
            );
          }),
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
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: getDrivers(),
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
                            ? Text("No Data yet")
                            : Report(snapshot.data, operators, usedQRCodes);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget Report(data, operators, usedQCodes) {
  return Column(
    children: [
      Text("Organisation Report", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
      const SizedBox(height: 20,),
      Row(
        children: [
          Text("Number of Drivers"),
          SizedBox(
            width: 10,
          ),
          Text(
            "${data.length}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      const SizedBox(height: 5,),
      if (operators != null)
        Row(
          children: [
            Text("Number of QR Codes"),
            SizedBox(
              width: 10,
            ),
            Text(
              "${operators.length + 1}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5,),
      if (usedQCodes != null)
        Row(
          children: [
            Text("Used QRCodes"),
            SizedBox(
              width: 10,
            ),
            Text(
              "${usedQCodes.length + 1}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 5,),
      if (usedQCodes != null)
        Row(
          children: [
            Text("Active QRCodes"),
            SizedBox(
              width: 10,
            ),
            Text(
              "${operators.length - usedQCodes.length}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
    ],
  );
}
