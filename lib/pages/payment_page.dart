import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var myAnswer = "";
  late final TextEditingController _phoneNumberController;
  final _focusPhoneNumber = FocusNode();

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<http.Response> getMtnSecretCode(String phone) {
    print("reached here");
    return http.post(
      Uri.parse('https://kasasira.herokuapp.com/send-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"mobile_money_company_id": "1", "phone": phone}),
    );
  }

  String dropdownvalue = 'Class 1';

  // List of items in our dropdown menu
  var items = [
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

  @override
  Widget build(BuildContext context) {
    print(feesPerItems[dropdownvalue]);
    return GestureDetector(
      onTap: () {
        _focusPhoneNumber.unfocus();
      },
      child: Scaffold(
        backgroundColor: Color(0xffF6F6F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text("Get Token"),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 30.0,
          ),
          child: Container(
            child: Column(
              children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text("Select Vehicle Type"),
              ],
            ),
            Row(
              children: [
                DropdownButton(
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
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
                  style:
                      TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Text("Ugx "),
                    Text("${feesPerItems[dropdownvalue]}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("Choose Payment Method"),
              ],
            ),
            const SizedBox(
              height: 20
            ),
            Row(
              children: [
                Container(
                  width: 150,
                  decoration: BoxDecoration(color: Colors.yellow),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "MTN",
                        style: TextStyle(color: Colors.black),
                      )),
                ),
                const SizedBox(
                  width: 18,
                ),
                Container(
                  width: 150,
                  decoration: BoxDecoration(color: Colors.red),
                  child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Airtel",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _phoneNumberController,
              focusNode: _focusPhoneNumber,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
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
                  // getMtnSecretCode(_phoneNumberController.text);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/make-payment', (route) => false);
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
