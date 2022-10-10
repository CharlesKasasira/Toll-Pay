import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tollpay/pages/account_page.dart';
import 'package:tollpay/pages/chat_page.dart';
import 'package:tollpay/pages/forgot_password.dart';
import 'package:tollpay/pages/generate.dart';
import 'package:tollpay/pages/home_page.dart';
import 'package:tollpay/pages/login_page.dart';
import 'package:tollpay/pages/maps_page.dart';
import 'package:tollpay/pages/operator/operator_dashboard.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/pages/payment_page.dart';
import 'package:tollpay/pages/signup_page.dart';
import 'package:tollpay/pages/splash_page.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Supabase.initialize(
    // TODO: Replace credentials with your own
    url: dotenv.env['YOUR_SUPABASE_URL'],
    anonKey: dotenv.env['YOUR_SUPABASE_ANNON_KEY'],
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
            statusBarColor: const Color(0xff1a1a1a),
            /* set Status bar color in Android devices. */
            statusBarIconBrightness: Brightness.light,
            /* set Status bar icons color in Android devices.*/
            statusBarBrightness:
                Brightness.light) /* set Status bar icon color in iOS. */
        );
    return GetMaterialApp(
      title: 'Toll Pay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light
        ),
        primaryColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.black,
          ),
        ), 
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/signup': (_) => const SignupPage(),
        '/account': (_) => const AccountPage(),
        '/dashboard': (_) => const HomePage(),
        '/org-dashboard': (_) => const OrganisationHomePage(),
        '/operator-dashboard': (_) => const OperatorHomePage(),
        '/forgot': (_) => const ForgotPage(),
        '/generate': (_) => GeneratePage(),
        '/map': (_) => const MyMap(),
        '/payment': (_) => PaymentPage(),
        '/chat': (_) => const ChatPage(),
      },
    );
  }
}
