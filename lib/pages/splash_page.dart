import 'package:flutter/material.dart';
import 'package:tollpay/components/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends AuthState<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      recoverSupabaseSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/TollPay-logo.png",
            width: 150,
          ),
          // Text("Toll Pay", style: TextStyle(fontSize: 30, color: Colors.white),),
        ],
      ),),
    );
  }
}
