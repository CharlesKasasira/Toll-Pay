import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tollpay/components/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends AuthState<SplashPage> with SingleTickerProviderStateMixin {
  var _visible = true;
  late AnimationController animationController;
  late Animation<double> animation;

  // startTime() async {
  //   var _duration = new Duration(seconds: 2);
  //   return new Timer(_duration, navigationPage);
  // }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      recoverSupabaseSession();
    });
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1),);
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/TollPay-logo.png",
            // width: 150,
            width: animation.value * 250,
                height: animation.value * 250,
          ),
          // Text("Toll Pay", style: TextStyle(fontSize: 30, color: Colors.white),),
        ],
      ),),
    );
  }
}
