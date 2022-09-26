import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_quickstart/components/auth_state.dart';
import 'package:supabase_quickstart/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  void moveToSignup() {
    Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    // final response = await supabase.auth.signIn(
    //     email: _emailController.text,
    //     options: AuthOptions(
    //         redirectTo: kIsWeb
    //             ? null
    //             : 'io.supabase.flutterquickstart://login-callback/'));

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
      appBar: AppBar(title: const Text('Sign In')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Sign in'),
          const SizedBox(height: 18),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 18),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: Text(_isLoading ? 'Loading' : 'Login'),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: moveToSignup,
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
