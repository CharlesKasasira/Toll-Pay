import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_state.dart';
import 'package:tollpay/screens/authentication/login_page.dart';
import 'package:tollpay/screens/authentication/signup_as_organisation.dart';
import 'package:tollpay/screens/authentication/signup_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../widgets/button.dart';

class SignUpAsPage extends StatefulWidget {
  const SignUpAsPage({Key? key}) : super(key: key);

  @override
  _SignUpAsPageState createState() => _SignUpAsPageState();
}

class _SignUpAsPageState extends AuthState<SignUpAsPage> {
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

  void moveToLogin() {
    Get.off(
      () => const LoginPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  void _signUpAsDriver() {
    Get.off(
      () => const SignupPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  void _signUpAsOrganisation() {
    Get.off(
      () => const SignUpOrg(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
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
                  const Text("Sign Up As", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10),
                  
                  const SizedBox(height: 18),
                  CustomElevatedButton(
                      onTap: _signUpAsDriver,
                      text: "Driver",),
                  const SizedBox(height: 18),

                  Row(
                  children: const [
                    Flexible(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 30,
                        endIndent: 20,
                      ),
                    ),
                    // SvgPicture.asset("assets/furniture_vector.svg"),
                    Text("OR"),
                    Flexible(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                        indent: 20,
                        endIndent: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                  CustomElevatedButton(
                      onTap: _signUpAsOrganisation,
                      text: "Organisation",),
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
