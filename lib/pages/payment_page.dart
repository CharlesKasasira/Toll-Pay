import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:tollpay/pages/generate.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';
import 'package:tollpay/widgets/myseparator.dart';

class PaymentPage extends StatefulWidget {
  var user;
  String? firstName;
  String? lastName;
  String? username;

  PaymentPage(
      {Key? key, this.user, this.firstName, this.lastName, this.username})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isAndroid = true;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _plateNumberController;
  late final TextEditingController _tripsController;
  final _focusPhoneNumber = FocusNode();
  final _focusPlateNumber = FocusNode();
  final _trips = FocusNode();

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

  void _tripsOnChanged(String val) {
    var amt = feesPerCar[dropdownCar];
    var amount = 2 * int.parse(amt!);
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

  String dropdownCar = 'Range Rover';
  // List of cars in our dropdown menu
  List<String> cars = [
    'Range Rover',
    'Truck',
  ];

  Map<String, String> feesPerCar = {
    "Range Rover": "5000",
    "Truck": "10000",
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
          backgroundColor: ksecondary,
          elevation: 0,
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Get Token",
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
        body: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 15.0,
          ),
          child: Container(
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pay for a registered Car",
                      style: TextStyle(),
                    ),
                    Switch(
                      // thumb color (round icon)
                      activeColor: Colors.greenAccent,
                      activeTrackColor: Colors.black,
                      inactiveThumbColor: Colors.black,
                      inactiveTrackColor: Colors.grey,
                      splashRadius: 50.0,
                      // boolean variable value
                      value: isAndroid,
                      // changes the state of the switch
                      onChanged: (value) => setState(() => isAndroid = value),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!isAndroid)
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vehicle Class",
                            style: TextStyle(),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: kTinGrey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton(
                              hint: const Text("Select Car Class"),
                              isDense: true,
                              isExpanded: true,
                              value: dropdownvalue,
                              dropdownColor: Colors.white,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },

                              // add extra sugar..
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 42,
                              underline: const SizedBox(),

                              // Array list of items
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),

                              // After selecting the desired option,it will
                              // change button value to selected value
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Plate Number'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _plateNumberController,
                            focusNode: _focusPlateNumber,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter plate number',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Select the Car"),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton(
                          // Initial Value
                          isExpanded: true,
                          value: dropdownCar,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownCar = newValue!;
                            });
                          },

                          // add extra sugar..
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 42,
                          underline: const SizedBox(),

                          // Array list of items
                          items: cars.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Number of Trips"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: _tripsController,
                      focusNode: _trips,
                      keyboardType: TextInputType.number,
                      onChanged: _tripsOnChanged,
                      decoration: inputDecorationConst.copyWith(
                        labelText: "trips",
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Amount to Pay",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Class fees"),
                        Text(!isAndroid
                              ? "${feesPerItems[dropdownvalue]}"
                              : "${feesPerCar[dropdownCar]}", style: const TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("trips"),
                        Text(_tripsController.text, style: const TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const MySeparator(color: Colors.grey),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("total"),
                        Text(!isAndroid
                              ? "${feesPerItems[dropdownvalue]}"
                              : "${feesPerCar[dropdownCar]}", style: const TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  color: kTinGrey,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: const [
                    Text(
                      "Choose Payment Method",
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xffffcc00),
                      border: Border.all(
                          color: selected == 2 ? kTinGrey : ksecondary),
                      borderRadius: BorderRadius.circular(8)),
                  child: CheckboxListTile(
                    activeColor: ksecondary,
                    // checkboxShape: ,
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: SvgPicture.asset(
                      "assets/icon/mtn.svg",
                      width: 50,
                    ),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      "${checkListItems[0]["title"]}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    value: checkListItems[0]["value"] == true,
                    onChanged: (value) {
                      setState(() {
                        for (var element in checkListItems) {
                          element["value"] = false;
                        }
                        checkListItems[0]["value"] = value;
                        selected = checkListItems[0]["id"];
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 10, right: 2),
                  decoration: BoxDecoration(
                      color: const Color(0xffee1c25),
                      border: Border.all(
                          color: selected == 1 ? kTinGrey : ksecondary),
                      borderRadius: BorderRadius.circular(8)),
                  child: CheckboxListTile(
                    activeColor: ksecondary,
                    // checkboxShape: ,
                    controlAffinity: ListTileControlAffinity.trailing,
                    secondary: SvgPicture.asset("assets/icon/airtel.svg"),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      "${checkListItems[1]["title"]}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    value: checkListItems[1]["value"] == true,
                    onChanged: (value) {
                      setState(() {
                        for (var element in checkListItems) {
                          element["value"] = false;
                        }
                        checkListItems[1]["value"] = value;
                        selected = checkListItems[1]["id"];
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (selected == 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phone Number'),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _phoneNumberController,
                        focusNode: _focusPhoneNumber,
                        keyboardType: TextInputType.number,
                        decoration: inputDecorationConst.copyWith(
                          labelText: 'Enter phone Number',
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                    "When using Airtel money, please initiate the transaction by getting the secret code",
                  ),
                const SizedBox(
                  height: 20,
                ),
                CustomElevatedButton(
                  onTap: () {
                    getMtnSecretCode(_phoneNumberController.text);
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25.0))),
                        // backgroundColor: Colors.grey,
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                  top: 20,
                                  right: 20,
                                  left: 20,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Center(
                                    child: Text(
                                      'Enter Secret Code',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  OTPTextField(
                                    length: 6,
                                    width: MediaQuery.of(context).size.width,
                                    fieldWidth: 30,
                                    style: TextStyle(fontSize: 14),
                                    textFieldAlignment:
                                        MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.underline,
                                    onCompleted: (pin) {
                                      // print("Completed: " + pin);
                                      makePayment(pin);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width -
                                          36,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.black),
                                      child: TextButton(
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ));
                  },
                  text: "Continue",
                ),
                const SizedBox(
                  height: 18,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
