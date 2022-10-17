import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_state.dart';
import 'package:tollpay/pages/login_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../widgets/button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends AuthState<SignupPage> {
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

  void moveToLogin() {
    Get.off(
      () => const LoginPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    final username = _namesController.text;
    final phoneNumber = _phoneNumberController.text;

    final response = await supabase.auth.signUp(
      _emailController.text,
      _passwordController.text,
      userMetadata: {
        "username": username,
        "roles": "driver",
        "phone": phoneNumber
      }
    );

    final error = response.error;
    if (error != null) {
      print(error);
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'You have created your account');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signup', (route) => false);
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
        resizeToAvoidBottomInset: true,
        body: ListView(children: [
          Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 18),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            child: ListView(children: [
              SizedBox(
                height: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Toll-Pay.png",
                    width: 80,
                  ),
                  const SizedBox(height: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email'),
                      const SizedBox(height: 5),
                      TextFormField(
                        cursorColor: ksecondary,
                        controller: _emailController,
                        focusNode: _focusEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecorationConst.copyWith(
                                labelText: "Enter Email",),
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
                        cursorColor: ksecondary,
                        controller: _namesController,
                        focusNode: _focusNames,
                        decoration: inputDecorationConst.copyWith(
                                labelText: "Enter Full Names",),
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
                        cursorColor: ksecondary,
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        focusNode: _focusPhoneNumber,
                        decoration: inputDecorationConst.copyWith(
                                labelText: "Enter Phone Number",),
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
                        cursorColor: ksecondary,
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        focusNode: _focusPassword,
                        decoration: inputDecorationConst.copyWith(
                                labelText: "Password",
                                suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: _togglePasswordVisibility,
                                  child: SvgPicture.asset(_showPassword ?
                                    "assets/icon/password_invisible.svg" : "assets/icon/password_visible.svg",
                                    height: 15,
                                    width: 20,
                                  ),
                                ),
                              ),
                              suffixIconConstraints:
                                  const BoxConstraints(maxWidth: 50),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  CustomElevatedButton(
                      onTap: _signUp,
                      text: "SIGN UP",),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account,"),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: moveToLogin,
                        child: const Text('Login', style: TextStyle(fontSize: 16, color: Color(0xff005620))),
                      ),
                    ],
                  ),
                  
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
