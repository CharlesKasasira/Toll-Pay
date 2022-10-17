import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tollpay/screens/login_page.dart';
import 'package:tollpay/screens/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({Key? key}) : super(key: key);

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  String? _avatarUrl;
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _namesController;
  late final TextEditingController _phoneNumberController;
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusNames = FocusNode();
  final _focusPhoneNumber = FocusNode();
  bool _showPassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    final username = _namesController.text;
    final phoneNumber = _phoneNumberController.text;

    final response = await supabase.auth
        .signUp(_emailController.text, _passwordController.text, userMetadata: {
      "username": username,
      "roles": "driver",
      "phone": phoneNumber,
      "organisation_id": supabase.auth.currentUser?.id
    });

    final error = response.error;
    if (error != null) {
      print(error);

      print(supabase.auth.currentUser?.id);
      context.showErrorSnackBar(message: error.message);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Successful"),
            content: const Text("The driver was added successfully"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"))
            ],
          );
        },
      );

      _emailController.clear();
      _passwordController.clear();
      _namesController.clear();
      _phoneNumberController.clear();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _namesController = TextEditingController();
    _phoneNumberController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _namesController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
        _focusNames.unfocus();
        _focusPhoneNumber.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: const Color.fromARGB(100, 158, 158, 158),
          backgroundColor: Color(0xff1a1a1a),
          elevation: 0,
          foregroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Add Driver",
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
                  Get.back();
                },
              ),
            );
          }),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(left: 18, right: 18, top: 18),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _focusEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter email',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Full Name'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _namesController,
                            focusNode: _focusNames,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter name',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Phone Number'),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberController,
                            focusNode: _focusPhoneNumber,
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Enter phone number',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Password'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            focusNode: _focusPassword,
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: _togglePasswordVisibility,
                                  child: SvgPicture.asset(
                                    _showPassword
                                        ? "assets/icon/password_invisible.svg"
                                        : "assets/icon/password_visible.svg",
                                    height: 15,
                                    width: 20,
                                  ),
                                ),
                              ),
                              suffixIconConstraints:
                                  const BoxConstraints(maxWidth: 50),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              isDense: true,
                              labelText: 'Enter Password',
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      CustomElevatedButton(
                        onTap: _signUp,
                        text: "ADD DRIVER",
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
