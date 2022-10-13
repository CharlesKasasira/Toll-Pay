import 'dart:convert';

// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/models/weather.dart';
import 'package:tollpay/pages/account_page.dart';
import 'package:tollpay/pages/scan_qr.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/operator_drawer.dart';

class OperatorHomePage extends StatefulWidget {
  const OperatorHomePage({Key? key}) : super(key: key);

  @override
  _OperatorHomePageState createState() => _OperatorHomePageState();
}

class _OperatorHomePageState extends AuthRequiredState<OperatorHomePage> {
  String? _userId;
  String? _avatarUrl;
  String? firstName;
  String? lastName;
  String? username;
  var _user;
  bool _loading = false;

  Future fetchWeather() async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Entebbe&units=metric&appid=${dotenv.env['WEATHER_API_KEY']}");
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.getWeather(json);
    } else {
      return null;
    }
  }

  void _goToScan() {
    Get.to(
      () => ScanPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
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
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    firstName = (data['first_name'] ?? '') as String;
    lastName = (data['last_name'] ?? '') as String;
    username = (data['username'] ?? '') as String;
    _avatarUrl = (data['avatar_url'] ?? '') as String;

    setState(() {
      _loading = false;
    });
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    _user = user;
    if (user != null) {
      _userId = user.id;
      _getProfile(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.kprimary,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: Color(0xff1a1a1a),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Home"),
            const SizedBox(
              width: 10,
            ),
            if (_avatarUrl == null || _avatarUrl!.isEmpty)
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => const AccountPage(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75.0),
                  child: Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.bottomCenter,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 200, 200, 200),
                    ),
                    child: Image.asset("assets/images/avatar_icon.png"),
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  Get.to(
                    () => const AccountPage(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75.0),
                  child: Image.network(
                    _avatarUrl!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
        leading: Builder(builder: (context) {
          return Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5),
            child: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 8.0,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Row(
              children: [
                const Text(
                  'Welcome, ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  '$username',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: _goToScan,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: const LinearGradient(
                    colors: [Colors.black, Color(0xff636363)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                          size: 100,
                        ),
                        Text(
                          "Scan QR code",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              child: FutureBuilder(
                future: fetchWeather(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                          height: 180,
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const Center(
                              child: CircularProgressIndicator(
                            color: Color(0xff1a1a1a),
                          )));
                    default:
                      return snapshot.data == null
                          ? Container(
                              height: 180,
                              padding: const EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(
                                      0,
                                      3,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Icon(Icons.wifi_off_outlined),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Check your internet connection.",
                                      style: TextStyle(
                                          fontFamily: "Spartan",
                                          color:
                                              Color.fromARGB(255, 24, 24, 24),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : getLocationScreen(snapshot.data);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      drawer: OperatorDrawer(
        user: _user,
        imageUrl: _avatarUrl,
        firstName: firstName,
        lastName: lastName,
        username: username,
      ),
    );
  }
}

Widget getLocationScreen(location) {
  Map<String, IconData> descList = {
    'Clouds': Icons.cloud_outlined,
    'Rain': FontAwesomeIcons.cloudRain,
    'Snow': FontAwesomeIcons.snowflake,
    'Drizzle': FontAwesomeIcons.cloudShowersHeavy,
    'Clear': FontAwesomeIcons.cloudShowersHeavy,
  };

  return Container(
    height: 180,
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    alignment: Alignment.center,
    // width: MediaQuery.of().size.width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              "http://openweathermap.org/img/wn/${location.icon}@2x.png",
            ),
            Text(
              "${location.description}",
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${location.temp}",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: ColorConstants.ksecondary,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "ENTEBBE",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Uganda",
              style: TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 62, 62, 62),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
