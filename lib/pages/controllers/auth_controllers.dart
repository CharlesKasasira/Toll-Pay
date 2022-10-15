import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tollpay/pages/home_page.dart';
import 'package:tollpay/pages/operator/operator_dashboard.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/constants.dart';

class AuthController extends GetxController {
  final _authController = Supabase.instance;
  User? get user => _authController.client.auth.currentUser;

  Future signIn(String email, String password) async {
    final response = await _authController.client.auth
        .signIn(email: email, password: password);
    if (response.error != null) {
      kDefaultDialog(
          "Error", response.error?.message ?? 'Some Unknown Error occurred');
    } else if (response.user != null) {

        dynamic meta = response.user?.userMetadata;

        if (meta['roles'] == "organization") {
          Get.to(
            () => const OrganisationHomePage(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        } else if (meta["roles"] == "operator") {
          Get.to(
            () => const OperatorHomePage(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        } else {
          Get.to(
            () => const HomePage(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        }
    }
  }

  Future forgotPassword(String email) async {
    await _authController.client.auth.api.resetPasswordForEmail(email);
    Get.snackbar("Password reset",
        "Password reset request has been sent to your email successfully.");
  }
}
