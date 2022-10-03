import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_state.dart';
import 'package:ysave/utils/constants.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends AuthState<SignupPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  void moveToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final response = await supabase.auth
        .signUp(_emailController.text, _passwordController.text);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'You have created your account');
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signup', (route) => false);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        children: [
          Container(
          padding: EdgeInsets.only(left: 18, right: 18),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              SizedBox(height: 25,),
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                            "assets/images/Toll-Pay.png",
                            width: 100,
                          ),
                // const Text(
                //   'Sign Up',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                // ),
                const SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Full Name'),
                    const SizedBox(height: 5),
                    TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: 'Enter fullname',
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
                    const Text('Email'),
                    const SizedBox(height: 5),
                    TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
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
                  controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Enter Phone Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                    
                  ],
                ),
                
                const SizedBox(height: 10),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Set Password'),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Enter password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                    
                  ],
                ),
                
                const SizedBox(height: 10),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Confirm Password'),
                    const SizedBox(height: 5),
                    TextFormField(
                      obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Enter password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                    
                  ],
                ),
                
                
                const SizedBox(height: 18),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 50,
                      child: ElevatedButton(
                        // style: ButtonStyle(
                          // padding: EdgeInsetsGeometry),
                    onPressed: _isLoading ? null : _signIn,
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
                SizedBox(height: 10,)
              ],
            ),]
          ),
        ),]
      ),
    );
  }
}
