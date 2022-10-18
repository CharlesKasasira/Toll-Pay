import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/components/auth_state.dart';
import 'package:tollpay/controllers/auth_controllers.dart';
import 'package:tollpay/screens/authentication/login_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/utils/validator.dart';
import 'package:tollpay/widgets/button.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends AuthState<ForgotPage> {
  final AuthController _authController = AuthController();
  bool _isLoading = false;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final _focusEmail = FocusNode();

  void moveToLogin() {
    Get.off(
      () => const LoginPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _authController.forgotPassword(_emailController.text);
      _emailController.clear();
    }
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/Toll-Pay.png",
                    width: 80,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Forgot Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(height: 18),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Email'),
                    const SizedBox(height: 5),
                    TextFormField(
                      cursorColor: ksecondary,
                      controller: _emailController,
                      focusNode: _focusEmail,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) => Validator.validateEmail(
                        email: value,
                      ),
                      decoration: inputDecorationConst.copyWith(
                        labelText: "Email",
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const SizedBox(height: 18),
              CustomElevatedButton(
                onTap: _resetPassword,
                text: "SUBMIT",
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remember password?,",
                    style: kNunitoSansSemiBold18.copyWith(
                      color: ksecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: moveToLogin,
                    child: const Text(
                      'Login',
                      style: kNunitoSansSemiBold18,
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
