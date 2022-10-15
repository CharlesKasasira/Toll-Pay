import 'package:flutter/material.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:supabase/supabase.dart';

class AppBarAvatar extends StatefulWidget {
  const AppBarAvatar({Key? key}) : super(key: key);

  @override
  State<AppBarAvatar> createState() => _AppBarAvatarState();
}

class _AppBarAvatarState extends State<AppBarAvatar> {
  String? _avatarUrl;
  String? _userId;
  var _user;

  // get users Profile
  Future<void> _getProfile(String userId) async {
    setState(() {});
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
    _avatarUrl = (data['avatar_url'] ?? '') as String;

    setState(() {});
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    _user = user;
    if (user != null) {
      _userId = user.id;
      _getProfile(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getProfile(supabase.auth.user()!.id);
    if (_avatarUrl == null || _avatarUrl!.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(75.0),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.bottomCenter,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 200, 200, 200),
          ),
          child: Image.asset("assets/images/avatar_icon.png"),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(75.0),
        child: Image.network(
          _avatarUrl!,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
