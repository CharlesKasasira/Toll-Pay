import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MakePaymentPage extends StatefulWidget {
  const MakePaymentPage({Key? key}) : super(key: key);

  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  var myAnswer = "";
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _amountController;
  late final TextEditingController _secretCodeController;
  late final TextEditingController _companyIDController;
  final _focusPhoneNumber = FocusNode();
  final _focusAmount = FocusNode();
  final _focusSecretCode = FocusNode();
  final _focusCompanyID = FocusNode();

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _amountController = TextEditingController();
    _secretCodeController = TextEditingController();
    _companyIDController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _amountController.dispose();
    _secretCodeController.dispose();
    _companyIDController.dispose();
    super.dispose();
  }

  Future<http.Response>? makePayment(
      String phone, String amount, String secretCode, String companyID) {
    // return http.post(
    //   Uri.parse('https://app.shineafrika.com/make-payment'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode(<String, String>{
    //     "amount": amount,
    //     "phone": phone,
    //     "secret_code": secretCode,
    //     "mobile_money_company_id": companyID,
    //     "reason": "Entebbe Express Toll Payment",
    //     "metadata": "Entebbe Express Toll Payment"
    //   }),
    // ).then((value) => value);
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/generate', (route) => false);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    int count = 0;
    return GestureDetector(
      onTap: () {
        _focusPhoneNumber.unfocus();
        _focusAmount.unfocus();
        _focusSecretCode.unfocus();
        _focusCompanyID.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x00000000),
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text("Make Payment"),
          leading: Builder(
            builder: (context) {
              return Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () =>
                    Navigator.of(context).pop(),
              ),
        );
            }
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 30.0,
          ),
          child: Container(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text("Choose Payment Method"),
                const SizedBox(
                  height: 20,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Secret Code'),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _secretCodeController,
                      focusNode: _focusSecretCode,
                      decoration: const InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        isDense: true,
                        labelText: 'Enter secret code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                  ],
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
                      makePayment(
                          _phoneNumberController.text,
                          _amountController.text,
                          _secretCodeController.text,
                          _companyIDController.text);
                    },
                    child: Text(
                      "Make Payment",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
