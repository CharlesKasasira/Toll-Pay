import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_required_state.dart';
import 'package:ysave/pages/generate.dart';
import 'package:ysave/utils/constants.dart';
import 'package:google_fonts/google_fonts.dart';

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
    Navigator.of(context).pushNamedAndRemoveUntil('/generate', (route) => false);
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

    // final myRoutes = {
    //   "/dashboard": "Dashboard",
    //   "/account": "Account"
    // };

    if (route != null) {
      pageName = route.settings.name == '/dashboard' ? "Dashboard" : "";
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 30.0,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            const Text(
              'Welcome back,',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            Text('$firstName $lastName',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No current QR code',
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(letterSpacing: .5),
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      Image.asset(
                        "assets/images/qr-code.png",
                        width: 100,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      "Generate new >",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                  )
                ],
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
            TextButton(
                onPressed: moveToMap,
                child: const Text('See Map')),
            TextButton(
                onPressed: moveToProfile, child: const Text('Scan QR Code')),
            TextButton(onPressed: _signOut, child: const Text('Sign Out')),
            TextButton(
                onPressed: moveToProfile, child: const Text('Go to Profile')),
          ],
        ),
      ),
    );
  }
}
