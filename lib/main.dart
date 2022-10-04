import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ysave/pages/account_page.dart';
import 'package:ysave/pages/forgot_password.dart';
import 'package:ysave/pages/generate.dart';
import 'package:ysave/pages/home_page.dart';
import 'package:ysave/pages/login_page.dart';
import 'package:ysave/pages/maps_page.dart';
import 'package:ysave/pages/signup_page.dart';
import 'package:ysave/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    // TODO: Replace credentials with your
    url: dotenv.env['YOUR_SUPABASE_URL'],
    anonKey: dotenv.env['YOUR_SUPABASE_ANNON_KEY'],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YSAVE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/account': (_) => const AccountPage(),
        '/dashboard': (_) => const HomePage(),
        '/forgot': (_) => const ForgotPage(),
        '/generate': (_) => GeneratePage(),
        '/map': (_) => MyMap(),
      },
    );
  }
}
