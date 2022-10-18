import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tollpay/models/user_data.dart';
import 'package:tollpay/utils/constants.dart';

class UserController extends GetxController {
  final _supabaseClient = Supabase.instance.client;
  UserData userData = UserData();

  Future fetchUserData() async {
    final response = await _supabaseClient
        .from("profiles")
        .select("")
        .eq("id", _supabaseClient.auth.user()?.id)
        .execute();
    userData = UserData.fromJson(response.data[0]);
    // update();
    print(userData);
  }

  void signOut() {
    kDefaultDialog(
      "Sign out",
      "Are you sure you want to sign out?",
      onYesPressed: () {
        _supabaseClient.auth.signOut();
        Get.deleteAll(force: true);
      },
    );
  }
}
