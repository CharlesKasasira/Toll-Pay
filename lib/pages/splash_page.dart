import 'package:flutter/material.dart';
import 'package:ysave/components/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends AuthState<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, LoginScreen.routeName, (route) => false);
      recoverSupabaseSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 5), () {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, LoginScreen.routeName, (route) => false);
    // });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),),
    );
  }
}
