import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_state.dart';
import 'package:tollpay/pages/login_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../widgets/button.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({Key? key}) : super(key: key);

  @override
  _ForgotPageState createState() => _ForgotPageState();
}

class _ForgotPageState extends AuthState<ForgotPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
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

  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.dark,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              const SizedBox(height: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Email'),
                    const SizedBox(height: 5),
                  TextFormField(
                  controller: _emailController,
                  focusNode: _focusEmail,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Enter email',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                )],
              ),
              const SizedBox(height: 18),
              
              const SizedBox(height: 18),
              CustomElevatedButton(
                      onTap: _resetPassword,
                      text: "SUBMIT",),
                  const SizedBox(
                    height: 10,
                  ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Remember password?,"),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: moveToLogin,
                    child: Text('Login', style: TextStyle(fontSize: 16, color: Color(0xff005620))),
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
