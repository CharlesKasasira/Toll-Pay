import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:tollpay/pages/generate.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/pages/qr_details.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';

class CarsPage extends StatefulWidget {
  var user;
  String? firstName;
  String? lastName;
  String? username;

  CarsPage(
      {Key? key, this.user, this.firstName, this.lastName, this.username})
      : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> {
  var myAnswer = "";
  String? _avatarUrl;
  bool isAndroid = false;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _plateNumberController;
  late final TextEditingController _tripsController;
  final _focusPhoneNumber = FocusNode();
  final _focusPlateNumber = FocusNode();
  final _trips = FocusNode();
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
  void initState() {
    _phoneNumberController = TextEditingController();
    _plateNumberController = TextEditingController();
    _tripsController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _plateNumberController.dispose();
    super.dispose();
  }

  Future<http.Response>? getMtnSecretCode(String phone) {
    return http.post(
      Uri.parse('https://app.shineafrika.com/api/send-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{"mobile_money_company_id": "1", "phone": phone},
      ),
    );
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('/make-payment', (route) => false);
    // return null;
  }

  Future<http.Response>? makePayment(String secretCode) {
    http
        .post(
          Uri.parse('https://app.shineafrika.com/api/make-payment'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "amount": feesPerItems[dropdownvalue].toString(),
            "phone": _phoneNumberController.text,
            "secret_code": secretCode,
            "mobile_money_company_id": "1",
            "reason": "Entebbe Express Toll Payment",
            "metadata": "Entebbe Express Toll Payment"
          }),
        )
        .then((value) => value);

    Future.delayed(const Duration(milliseconds: 1000), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GeneratePage(
                  amount: feesPerItems[dropdownvalue],
                  phone: _phoneNumberController.text,
                  plate: _plateNumberController.text,
                  count: _tripsController.text,
                  username: widget.username,
                  user: widget.user)));
      setState(() {});
    });

    return null;
  }

  String dropdownvalue = 'Class 1';

  // List of items in our dropdown menu
  List<String> items = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
  ];

  Map<String, String> feesPerItems = {
    "Class 1": "3,000",
    "Class 2": "5,000",
    "Class 3": "10,000",
    "Class 4": "15,000",
    "Class 5": "18,000",
  };

  List<String> cars = [
    'Range Rover',
    'Truck',
  ];

  Map<String, String> feesPerCar = {
    "Range Rover": "5,000",
    "Truck": "10,000",
  };

  dynamic selected = 1;

  List checkListItems = [
    {
      "id": 1,
      "value": false,
      "title": "MTN MoMo",
    },
    {
      "id": 2,
      "value": false,
      "title": "Airtel Money",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusPhoneNumber.unfocus();
        _focusPlateNumber.unfocus();
        _trips.unfocus();
      },
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
                "Registered Cars",
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
                },
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
