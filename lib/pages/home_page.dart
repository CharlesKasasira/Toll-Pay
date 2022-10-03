import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_required_state.dart';
import 'package:ysave/pages/generate.dart';
import 'package:ysave/pages/payment_page.dart';
import 'package:ysave/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ysave/models/weather.dart';
import 'package:ysave/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  String? _userId;
  String? _avatarUrl;
  String? firstName;
  String? lastName;
  var _loading = false;

  Future fetchWeather() async {
    var url = Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=93ec627bbff54c968ed133550212210&q=entebbe");
    http.Response response = await http.get(url);
    //status codes : 200 success, 404 city not found, 401 invalid API key
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return Weather.getWeather(data);
      // return rest;
    } else {
      print("Not found");
      return null;
    }
  }

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
    lastName = (data['last_name'] ?? '') as String;

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
    Navigator.of(context).pushNamedAndRemoveUntil('/account', (route) => false);
  }

  void moveToGenerate() async {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/generate', (route) => false);
  }

  void moveToMap() async {
    Navigator.of(context).pushNamedAndRemoveUntil('/map', (route) => false);
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

    if (route != null) {
      pageName = route.settings.name == '/dashboard' ? "Dashboard" : "";
    }

    return Scaffold(
      backgroundColor: Color(0xffF6F6F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: null,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 8.0,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Row(
              children: [
                const Text(
                  'Hi, ',
                  style: TextStyle(),
                ),
                Text('$firstName',
                    style:
                        const TextStyle()),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                    colors: [Colors.black, Color(0xff636363)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
        
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'No current',
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(letterSpacing: .5),
                                fontSize: 18,
                                color: Colors.white),
                          ),
                          Text(
                            'QR code',
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(letterSpacing: .5),
                                fontSize: 30,
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          
                        ],
                      ),
                      Image.asset(
                            "assets/images/qr-code.png",
                            width: 100,
                          ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentPage()),
                    );
                    },
                    child: const Text(
                      "Pay now >",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: FutureBuilder(
                future: this.fetchWeather(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      return snapshot.data == null
                          ? Container(
                              // ignore: prefer_const_constructors
                              child: Center(
                                child: Text(
                                  "City Not Found.",
                                  style: TextStyle(
                                      fontFamily: "Spartan",
                                      fontSize: 35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          : Text("hello");
                  }
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: const Text("You made it."),
            ),
            TextButton(
                onPressed: moveToGenerate,
                child: const Text('Generate QR Code')),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

