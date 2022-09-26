import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_required_state.dart';
import 'package:ysave/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  String? _userId;
  String? _avatarUrl;
  String? firstName;
  var _loading = false;

  //get users Profile
  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    firstName = (data['first_name'] ?? '') as String;
    print(firstName);
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  void moveToProfile() async {
    Navigator.of(context)
          .pushNamedAndRemoveUntil('/account', (route) => false);
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _userId = user.id;
      _getProfile(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    var pageName = "";

    // final myRoutes = {
    //   "/dashboard": "Dashboard",
    //   "/account": "Account"
    // };

    if (route != null) {
      pageName = route.settings.name == '/dashboard' ? "Dashboard" : "";
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 30.0,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Text('Welcome $firstName'),
            const SizedBox(height: 18),
            Text(
              'UGX 2000',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(letterSpacing: .5),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: BezierChart(
                  bezierChartScale: BezierChartScale.CUSTOM,
                  xAxisCustomValues: const [0, 5, 10, 15, 20, 25, 30],
                  series: const [
                    BezierLine(
                      data: const [
                        DataPoint<double>(value: 10, xAxis: 0),
                        DataPoint<double>(value: 130, xAxis: 5),
                        DataPoint<double>(value: 50, xAxis: 10),
                        DataPoint<double>(value: 150, xAxis: 15),
                        DataPoint<double>(value: 75, xAxis: 20),
                        DataPoint<double>(value: 0, xAxis: 25),
                        DataPoint<double>(value: 5, xAxis: 30)
                      ],
                    ),
                  ],
                  config: BezierChartConfig(
                    verticalIndicatorStrokeWidth: 3.0,
                    verticalIndicatorColor: Colors.black26,
                    showVerticalIndicator: true,
                    snap: false,
                  ),
                )),
            TextButton(onPressed: _signOut, child: const Text('Sign Out')),
            TextButton(
                onPressed: moveToProfile, child: const Text('Go to Profile')),
          ],
        ),
      ),
    );
  }
}
