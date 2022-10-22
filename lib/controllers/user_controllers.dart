import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  Future<http.Response> createUser(
    String username,
    String roles,
    String phoneNumber,
    String email,
    String password,
  ) {
    return http.post(
      Uri.parse('https://app.shineafrika.com/api/add-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "username": username,
        "roles": roles,
        "organisation_id": _supabaseClient.auth.user()!.id
      }),
    );
  }


  Future<http.Response> deleteUser(
    String userId,
    String username,
    String roles
  ) {
    return http.post(
      Uri.parse('https://app.shineafrika.com/api/delete-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "roles": roles,
        "userId": userId,
        "username": username,
        "actor_id": _supabaseClient.auth.user()!.id
      }),
    );
  }
}
