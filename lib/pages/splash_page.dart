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
    Future.delayed(const Duration(seconds: 2), () {
      recoverSupabaseSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/Toll-Pay.png",
            width: 100,
          ),
          Text("Toll Pay", style: TextStyle(fontSize: 30, color: Colors.white),),
        ],
      ),),
    );
  }
}
