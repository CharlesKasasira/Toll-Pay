import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/pages/myqr_page.dart';
import 'package:tollpay/pages/organisation/bar_chart.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/utils/fetch_weather.dart';
import 'package:tollpay/utils/price_point.dart';
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
  var _user;

  Future getActiveQRCodes() async {
    final response = await supabase.from('qrcodes').select().execute();

    final data = response.data;
    final error = response.error;

    if (data != null) {
      activeQrCodes = data.length;
    } else {
      activeQrCodes = "0";
    }
    // if (error != null) {
    //   print(error.message);
    // }
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
      // ignore: use_build_context_synchronously
      context.showErrorSnackBar(message: error.message);
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
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getActiveQRCodes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: Color(0xff1a1a1a),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 10,
            ),
            if (_avatarUrl == null || _avatarUrl!.isEmpty)
              ClipRRect(
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
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(75.0),
                child: Image.network(
                  _avatarUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
          ],
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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
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
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: "NunitoSans"),
                  ),
                ],
              ),
              const Text(
                "Welcome to your dashboard",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '13',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(letterSpacing: .5),
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Drivers',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(letterSpacing: .5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.groups_outlined,
                          color: Colors.white,
                          size: 60,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),

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
                  decoration: BoxDecoration(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                'Active QR Codes',
                                style: GoogleFonts.roboto(
                                    textStyle:
                                        const TextStyle(letterSpacing: .5),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.qr_code,
                            color: Colors.white,
                            size: 60,
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
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '10',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(letterSpacing: .5),
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Registered Cars',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(letterSpacing: .5),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.car_rental,
                          color: Colors.white,
                          size: 60,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 18,),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
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
                      const Text("QR Codes per day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      const SizedBox(height: 15,),
                      Row(
                        children: [
                          const SizedBox(width: 12,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xffd7eb00),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text("This week", style: TextStyle(fontWeight: FontWeight.bold),)
                          ),
                          const SizedBox(width: 10,),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              // color: Color(0xffd7eb00),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text("Last week", style: TextStyle(),)
                          )
                        ],
                      ),
                      const SizedBox(height: 15,),
                      BarChartWidget(points: pricePoints),
                    ],
                  )),
              const SizedBox(
                height: 10,
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
    padding: const EdgeInsets.all(10),
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
