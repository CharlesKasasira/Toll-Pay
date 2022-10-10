import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:tollpay/pages/generate.dart';

class PaymentPage extends StatefulWidget {
  var user;
  String? firstName;
  String? lastName;
  PaymentPage({Key? key, this.user, this.firstName, this.lastName, String? username})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var myAnswer = "";
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _plateNumberController;
  final _focusPhoneNumber = FocusNode();
  final _focusPlateNumber = FocusNode();

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _plateNumberController = TextEditingController();
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
    int count = 0;
    return GestureDetector(
      onTap: () {
        _focusPhoneNumber.unfocus();
        _focusPlateNumber.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0x00000000),
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text("Get Token"),
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 30.0,
          ),
          child: Container(
            child: ListView(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Vehicle Type",
                      style: TextStyle(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton(
                        // Initial Value
                        isExpanded: true,
                        value: dropdownvalue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },

                        // add extra sugar..
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 42,
                        underline: SizedBox(),

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount to Pay",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text("Ugx "),
                        Text(
                          "${feesPerItems[dropdownvalue]}",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Plate Number'),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _plateNumberController,
                        focusNode: _focusPlateNumber,
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter plate number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      "Choose Payment Method",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Column(
                    children: List.generate(
                  checkListItems.length,
                  (index) => CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      "${checkListItems[index]["title"]}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    value: checkListItems[index]["value"] == true,
                    onChanged: (value) {
                      setState(() {
                        for (var element in checkListItems) {
                          element["value"] = false;
                        }
                        checkListItems[index]["value"] = value;
                        selected = checkListItems[index]["id"];
                        // selected =
                        //     "${checkListItems[index]["id"]}, ${checkListItems[index]["title"]}, ${checkListItems[index]["value"]}";
                      });
                    },
                  ),
                )),
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
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const Text(
                      "When using Airtel money, please initiate the transaction by getting the secret cod"),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 36,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black),
                  child: TextButton(
                    // style: ButtonStyle(
                    // padding: EdgeInsetsGeometry),
                    onPressed: () {
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
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                36,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.black),
                                        child: TextButton(
                                          child: const Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ),
                              ));
                    },
                    child: Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
