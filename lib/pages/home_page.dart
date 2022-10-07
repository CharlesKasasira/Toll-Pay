import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ysave/components/auth_required_state.dart';
import 'package:ysave/pages/generate.dart';
import 'package:ysave/pages/payment_page.dart';
import 'package:ysave/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
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
  bool _loading = false;

  Future fetchWeather() async {
    print("start fetch !");
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Entebbe&units=metric&appid=${dotenv.env['WEATHER_API_KEY']}");
    http.Response response = await http.get(url);
    //status codes : 200 success, 404 city not found, 401 invalid API key
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Weather.getWeather(json);
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
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        shadowColor: null,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text("Home"),
        leading: Builder(builder: (context) {
          return Container(
            width: 25,
            height: 25,
            margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: new IconButton(
              icon: new Icon(Icons.menu, color: Colors.black),
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
                  '$firstName',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
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
                    end: Alignment.bottomRight),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
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
                        MaterialPageRoute(
                            builder: (context) => const PaymentPage()),
                      );
                    },
                    child: const Text(
                      "Pay now >",
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                      return Container(
                          height: 180,
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
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
            const Text(
              "Last QR Codes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(""),
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

Widget getLocationScreen(location) {
  print(location);
  List<IconData> gridIcons = [
    FontAwesomeIcons.thermometerThreeQuarters,
    FontAwesomeIcons.temperatureLow,
    FontAwesomeIcons.temperatureHigh,
    FontAwesomeIcons.tachometerAlt,
    FontAwesomeIcons.tint,
    FontAwesomeIcons.wind
  ];
  List<String> gridHeaders = [
    'Feels like',
    'Temp min',
    'Temp max',
    'Pressure',
    'Humidity',
    'Wind'
  ];

  Map<String, IconData> descList = {
    'Clouds': Icons.cloud_outlined,
    'Rain': FontAwesomeIcons.cloudRain,
    'Snow': FontAwesomeIcons.snowflake,
    'Drizzle': FontAwesomeIcons.cloudShowersHeavy,
  };

  // List<String> gridValues = [
  //   location.feelsLike,
  //   location.tempMin,
  //   location.tempMax,
  //   location.pressure,
  //   location.humidity,
  //   location.windspeed
  // ];

  // Color screenColor = colorList[Random().nextInt(colorList.length)];

  return Container(
    height: 180,
    padding: EdgeInsets.all(10),
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
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),

    child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: 100,
                height: 100,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: FaIcon(
                  descList[location.description],
                  size: 60,
                  // color: Color(0x5f1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${location.description}",
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${location.temp}",
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1a1a1a)),
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
        ]),
  );
}
