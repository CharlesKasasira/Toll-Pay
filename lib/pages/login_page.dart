// ignore_for_file: unnecessary_statements

import 'package:flutter/material.dart';
import 'package:tollpay/components/auth_state.dart';
import 'package:tollpay/pages/forgot_password.dart';
import 'package:tollpay/pages/signup_as_page.dart';
import 'package:tollpay/pages/signup_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/utils/validator.dart';
import 'package:tollpay/widgets/button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void moveToSignup() {
    Get.off(
      () => const SignUpAsPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  void moveToForgot() {
    Get.off(
      () => const ForgotPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    final user = response.user;

    if (user != null) {
      print(user.userMetadata);
      final meta = user.userMetadata;
      print(meta);
      if (meta["roles"] == "organization") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/org-dashboard', (route) => false);
        _emailController.clear();
        _passwordController.clear();
      } else if (meta["roles"] == "operator") {
        print("here");
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/operator-dashboard', (route) => false);
        _emailController.clear();
        _passwordController.clear();
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/dashboard', (route) => false);
        _emailController.clear();
        _passwordController.clear();
      }
    }

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 60),
          child: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            reverse: true,
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 18, right: 18),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    "assets/images/Toll-Pay.png",
                    width: 80,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(children: [
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
                            validator: (value) => Validator.validateEmail(
                              email: value,
                            ),
                            decoration: const InputDecoration(
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Email',
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
                            validator: (value) => Validator.validatePassword(
                              password: value,
                            ),
                            decoration: InputDecoration(
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                  onTap: _togglePasswordVisibility,
                                  child: SvgPicture.asset(
                                    "assets/icon/password_visible.svg",
                                    height: 15,
                                    width: 20,
                                  ),
                                ),
                              ),
                              suffixIconConstraints:
                                  const BoxConstraints(maxWidth: 50),
                              isDense: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelText: 'Password',
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomElevatedButton(
                    onTap: _signIn,
                    text: "LOGIN",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: moveToForgot,
                        child: const Text(
                          'Forgot Password?',
                          style:
                              TextStyle(fontSize: 16, color: Color(0xff005620)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account,",
                          style: TextStyle(fontSize: 16)),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: moveToSignup,
                        child: const Text('Sign Up',
                            style: TextStyle(color: Color(0xff005620))),
                      ),
                    ],
                  ),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
