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

  @override
  void onAuthenticated(Session session) {
    final meta = session.user;
    if (mounted) {
      if(meta?.userMetadata['roles'] == "operator"){
        Navigator.of(context)
          .pushNamedAndRemoveUntil('/operator-dashboard', (route) => false);
      } else if (meta?.userMetadata['roles'] == "organization"){
        Navigator.of(context)
          .pushNamedAndRemoveUntil('/org-dashboard', (route) => false);
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
