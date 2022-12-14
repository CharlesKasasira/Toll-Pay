import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/screens/myqr_page.dart';
import 'package:tollpay/screens/organisation/bar_chart.dart';
import 'package:tollpay/screens/organisation/cars_page.dart';
import 'package:tollpay/screens/organisation/drivers/drivers_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/utils/fetch_weather.dart';
import 'package:tollpay/utils/get_weather.dart';
import 'package:tollpay/utils/price_point.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/organization_drawer.dart';

class OrganisationHomePage extends StatefulWidget {
  const OrganisationHomePage({Key? key}) : super(key: key);

  @override
  _OrganisationHomePageState createState() => _OrganisationHomePageState();
}

class _OrganisationHomePageState
    extends AuthRequiredState<OrganisationHomePage> {
  String? _userId;
  String? _avatarUrl;
  String? firstName;
  String? lastName;
  String? username;
  var activeQrCodes;
  var registeredCar;
  var drivers;
  var _user;
  String week = "last";

  Future getActiveQRCodes() async {
    final response = await supabase.from('qrcodes').select().execute();

    final data = response.data;
    final error = response.error;

    if (data != null) {
      activeQrCodes = data.length;
    } else {
      activeQrCodes = "0";
    }
  }

  Future getRegisteredCars() async {
    final response = await supabase.from('cars').select().execute();

    final data = response.data;
    final error = response.error;

    if (data != null) {
      registeredCar = data.length;
    } else {
      registeredCar = "0";
    }
  }

  Future getDrivers() async {
    final response = await supabase
        .from('profiles')
        .select()
        .eq("roles", "driver")
        .eq("organisation_id", supabase.auth.user()!.id)
        .execute();

    final data = response.data;
    final error = response.error;

    if (data != null) {
      drivers = data.length;
    } else {
      drivers = "0";
    }
  }

  //get users Profile
  Future<void> _getProfile(String userId) async {
    setState(() {});
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    if (error != null && response.status != 406) {
      // context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    firstName = (data['first_name'] ?? '') as String;
    lastName = (data['last_name'] ?? '') as String;
    _avatarUrl = (data['avatar_url'] ?? '') as String;
    username = (data['username'] ?? '') as String;

    setState(() {});
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    _user = user;
    if (user != null) {
      _userId = user.id;
      _getProfile(user.id);
      getActiveQRCodes();
      getRegisteredCars();
      getDrivers();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getActiveQRCodes();
    getRegisteredCars();
    getDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: const Color(0xff1a1a1a),
        elevation: 1,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [Text("Home"), AppBarAvatar()],
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 8.0,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
            children: [
              Row(
                children: [
                  const Text(
                    'Hello, ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '$username',
                    style: kNunitoSansSemiBold18.copyWith(color: ksecondary),
                  ),
                ],
              ),
              const Text(
                "Welcome to your dashboard",
                style: TextStyle(color: kTinGrey),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DriversPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ksecondary,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff1a1a1a),
                            Color.fromARGB(255, 57, 57, 57)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '$drivers',
                                    style: GoogleFonts.roboto(
                                        textStyle:
                                            const TextStyle(letterSpacing: .5),
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Drivers',
                                    style: GoogleFonts.roboto(
                                        textStyle:
                                            const TextStyle(letterSpacing: .5),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.drive_eta_rounded,
                                color: Colors.white,
                                size: 30,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: (MediaQuery.of(context).size.width - 50) / 2,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
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
                    child: FutureBuilder(
                      future: fetchWeather(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff1a1a1a),
                              ),
                            );
                          default:
                            return snapshot.data == null
                                ? Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          style: kNunitoSansSemiBold18,
                                        ),
                                      ],
                                    ),
                                  )
                                : getWeather(snapshot.data);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyQRCodes(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 15, 113, 48),
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 15, 113, 48),
                            Color.fromARGB(200, 15, 113, 48)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${activeQrCodes}',
                                    style: GoogleFonts.roboto(
                                        textStyle:
                                            const TextStyle(letterSpacing: .5),
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'QR Codes',
                                    style: GoogleFonts.roboto(
                                        textStyle:
                                            const TextStyle(letterSpacing: .5),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.qr_code,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarsPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blue.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${registeredCar}",
                                    style: GoogleFonts.roboto(
                                        textStyle:
                                            const TextStyle(letterSpacing: .5),
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Cars',
                                    style: GoogleFonts.roboto(
                                        textStyle:
                                            const TextStyle(letterSpacing: .5),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.car_rental,
                                color: Colors.white,
                                size: 30,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      top: 20, left: 10, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "QR Codes per day",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                week = "last";
                              });
                            },
                            child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: week == "last"
                                      ? ksecondary.withOpacity(0.8)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  "Last week",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: week == "last"
                                        ? Colors.white
                                        : ksecondary,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("tapped");
                              setState(() {
                                week = "this";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: week == "this"
                                      ? ksecondary.withOpacity(0.8)
                                      : Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text(
                                "This week",
                                style: TextStyle(
                                  color: week == "this"
                                        ? Colors.white
                                        : ksecondary,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BarChartWidget(points: week == "last" ? lastWeekPoints : thisWeekPoints),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      drawer: OrganisationDrawer(
        user: _user,
        imageUrl: _avatarUrl,
        firstName: firstName,
        lastName: lastName,
        username: username,
      ),
    );
  }
}
