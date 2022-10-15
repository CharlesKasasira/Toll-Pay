import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/pages/organisation/add_driver.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/get_drivers.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';
import 'package:tollpay/widgets/drivers_list.dart';
import 'package:tollpay/widgets/empty_widget.dart';

class DriversPage extends StatefulWidget {
  var user;
  String? firstName;
  String? lastName;
  String? username;

  DriversPage(
      {Key? key, this.user, this.firstName, this.lastName, this.username})
      : super(key: key);

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  String? _avatarUrl;
  bool isAndroid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          shadowColor: const Color.fromARGB(100, 158, 158, 158),
          backgroundColor: Color(0xff1a1a1a),
          elevation: 0,
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Drivers",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              const SizedBox(
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
                // onPressed: () => Navigator.of(context).pop(),
                onPressed: () {
                  Get.off(
                    () => const OrganisationHomePage(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                  // Get.back();
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
                Align(
                  alignment: Alignment.topLeft,
                  child: CustomElevatedButton(
                      onTap: () {
                        Get.to(
                          () => const AddDriver(),
                          transition: Transition.cupertino,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                        );
                      },
                      text: "Add Driver"),
                ),
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
                            ? const Empty()
                            : driversList(snapshot.data);
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
