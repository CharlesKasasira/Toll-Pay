import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_quickstart/components/auth_required_state.dart';
import 'package:supabase_quickstart/utils/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends AuthRequiredState<HomePage> {
  @override
  Widget build(BuildContext context) {
    var route = ModalRoute.of(context);
    var pageName = "";

    var _myRoutes = {
      "/dashboard": "Dashboard",
      "/account": "Account"
    };

    if (route != null) {
      pageName = route.settings.name == '/dashboard' ? "Dashboard" : "Not";
    }

    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const Text('Welcome'),
          const SizedBox(height: 18),
          // ElevatedButton(
          //   onPressed: {},
          //   child: Text('Sign Up'),
          // ),
        ],
      ),
    );
  }
}
