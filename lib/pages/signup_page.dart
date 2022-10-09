import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_state.dart';
import 'package:tollpay/utils/constants.dart';

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

  void moveToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
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
        "phone": phoneNumber
      },
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
                    width: 100,
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
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          isDense: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter phone number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          labelText: 'Enter Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 36,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          child: Text(_isLoading ? 'Loading' : 'Sign Up'),
                        ),
                      ),
                    ],
                  ),
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
                        child: Text('Login'),
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
