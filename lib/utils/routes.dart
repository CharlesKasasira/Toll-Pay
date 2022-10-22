import 'package:flutter/material.dart';
import 'package:tollpay/screens/account_page.dart';
import 'package:tollpay/screens/admin/admin_dashboard.dart';
import 'package:tollpay/screens/authentication/forgot_password.dart';
import 'package:tollpay/screens/authentication/login_page.dart';
import 'package:tollpay/screens/authentication/signup_page.dart';
import 'package:tollpay/screens/chat_page.dart';
import 'package:tollpay/screens/generate.dart';
import 'package:tollpay/screens/home_page.dart';
import 'package:tollpay/screens/maps_page.dart';
import 'package:tollpay/screens/operator/operator_dashboard.dart';
import 'package:tollpay/screens/organisation/organisation_dashboard.dart';
import 'package:tollpay/screens/payment_page.dart';
import 'package:tollpay/screens/splash_page.dart';


Map<String, WidgetBuilder> get routes {
    return <String, WidgetBuilder>{
      '/': (_) => const SplashPage(),
      '/login': (_) => const LoginPage(),
      '/signup': (_) => const SignupPage(),
      '/account': (_) => const AccountPage(),
      '/dashboard': (_) => const HomePage(),
      '/org-dashboard': (_) => const OrganisationHomePage(),
      '/operator-dashboard': (_) => const OperatorHomePage(),
      '/admin-dashboard': (_) => const AdminHomePage(),
      '/forgot': (_) => const ForgotPage(),
      '/generate': (_) => GeneratePage(),
      '/map': (_) => MyMap(),
      '/payment': (_) => PaymentPage(),
      '/chat': (_) => const ChatPage(),
    };
  }