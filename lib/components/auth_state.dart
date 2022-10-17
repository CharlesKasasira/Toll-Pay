import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tollpay/utils/constants.dart';

class AuthState<T extends StatefulWidget> extends SupabaseAuthState<T> {
  @override
  void onUnauthenticated() {
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  String? roles;
  Future<void> _getProfile(String userId) async {
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
    roles = (data['roles'] ?? '') as String;

    print("the data role is $data");
  }

  @override
  void onAuthenticated(Session session) async {
    _getProfile(session.user!.id);
    final meta = session.user;

    final res = await supabase
        .from('profiles')
        .select()
        .eq('id', session.user!.id)
        .single()
        .execute();

    roles = (res.data['roles'] ?? '') as String;

    print(res.data);

    //get users Profile
    if (mounted) {
      if (meta?.userMetadata['roles'] == "operator") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/operator-dashboard', (route) => false);
      } else if (meta?.userMetadata['roles'] == "organization") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/org-dashboard', (route) => false);
      } else if (roles == "admin") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/admin-dashboard', (route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/dashboard', (route) => false);
      }
    }
  }

  @override
  void onPasswordRecovery(Session session) {}

  @override
  void onErrorAuthenticating(String message) {
    context.showErrorSnackBar(message: message);
  }
}
