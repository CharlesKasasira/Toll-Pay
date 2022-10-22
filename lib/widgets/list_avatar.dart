import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/screens/account_page.dart';
import 'package:tollpay/utils/constants.dart';

class ListAvatar extends StatefulWidget {
  var avatar;
  ListAvatar({Key? key, required this.avatar}) : super(key: key);

  @override
  State<ListAvatar> createState() => _ListAvatarState();
}

class _ListAvatarState extends State<ListAvatar> {
  String? _avatarUrl;
  String? username;
  DateTime? created_at;
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
    username = (data['username'] ?? '') as String;
    created_at = (data['created_at'] ?? '') as DateTime;

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
    if (widget.avatar == null) {
      return GestureDetector(
        onTap: () {
          Get.to(
            () => const AccountPage(),
            curve: Curves.easeOut,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(75.0),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 200, 200, 200),
            ),
            child: Image.asset("assets/images/avatar_icon.png"),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Get.to(
            () => const AccountPage(),
            curve: Curves.easeOut,
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(75.0),
          child: Image.network(
            "https://ixzongeybqpyreokewbc.supabase.co/storage/v1/object/public/avatars/2022-10-08T10:23:43.002626.jpg",
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
