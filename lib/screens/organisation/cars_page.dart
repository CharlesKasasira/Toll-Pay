import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tollpay/screens/generate.dart';
import 'package:tollpay/screens/organisation/add_car.dart';
import 'package:tollpay/screens/organisation/car_details.dart';
import 'package:tollpay/screens/organisation/organisation_dashboard.dart';
import 'package:tollpay/screens/qr_details.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';

class CarsPage extends StatefulWidget {
  CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  var myAnswer = "";
  String? _avatarUrl;
  bool isAndroid = false;
  final _focusPhoneNumber = FocusNode();
  final _focusPlateNumber = FocusNode();
  final _trips = FocusNode();
  var activeQrCodes;

  Future getCars() async {
    final response =
        await supabase.from('cars').select().order('created_at').execute();

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        appBar: AppBar(
          shadowColor: const Color.fromARGB(100, 158, 158, 158),
          backgroundColor: ksecondary,
          elevation: 0,
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Registered Cars",
                style: TextStyle(fontWeight: FontWeight.w400),
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
                CustomElevatedButton(
                    onTap: () {
                      Get.to(
                        () => const AddCar(),
                        transition: Transition.cupertino,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                      );
                    },
                    text: "Add New Car",),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: getCars(),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              color: Color.fromARGB(
                                                  255, 24, 24, 24),
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
          elevation: 1,
          child: ListTile(
            leading: const Icon(Icons.car_crash),
            title: Text(
              "${location[index]['plate_number']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Class ${location[index]['class']}"),
            onTap: () {
              Get.to(
                () => CarDetails(id: location[index]['id']),
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
