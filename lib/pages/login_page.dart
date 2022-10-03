import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_state.dart';
import 'package:ysave/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:ysave/utils/validator.dart';

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

  void moveToSignup() {
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
  }

  void moveToForgot() {
    Navigator.of(context).pushNamedAndRemoveUntil('/forgot', (route) => false);
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/dashboard', (route) => false);
      _emailController.clear();
      _passwordController.clear();
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
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                        "assets/images/Toll-Pay.png",
                        width: 100,
                      ),
              // const Text(
              //   'Login',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              // ),
              const SizedBox(height: 50),
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
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    obscureText: true,
                    focusNode: _focusPassword,
                    validator: (value) => Validator.validatePassword(
                      password: value,
                    ),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _isLoading ? Color(0xFFe5e5e5) : Colors.black),
                child: TextButton(
                  // style: ButtonStyle(
                  // padding: EdgeInsetsGeometry),
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? Text('Loading', style: TextStyle(color: Color(0xFFa3a3a3)))
                      : Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
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
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 16),
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
                    child: Text('Sign Up'),
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
