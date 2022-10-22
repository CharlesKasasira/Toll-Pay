import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/controllers/auth_controllers.dart';
import 'package:tollpay/screens/account_page.dart';
import 'package:tollpay/screens/admin/admin_reports.dart';
import 'package:tollpay/screens/admin/logs.dart';
import 'package:tollpay/screens/admin/operators.dart';
import 'package:tollpay/screens/chat_page.dart';
import 'package:tollpay/screens/chat_with.dart';
import 'package:tollpay/utils/constants.dart';

class AdminDrawer extends StatefulWidget {
  var user;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? username;
  AdminDrawer(
      {this.user,
      this.imageUrl,
      this.firstName,
      this.lastName,
      this.username,
      Key? key})
      : super(key: key);

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  final AuthController _authController = AuthController();
  // String? username;
  String? _userId;
  String? _avatarUrl;
  var _loading = false;

  Future<void> _getProfile(String userId) async {
    setState(() {
      _loading = true;
    });
    final response = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    final error = response.error;
    final data = response.data;
    if (data != null) {
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: ksecondary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(75.0),
                    child: Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 200, 200, 200),
                      ),
                      child: Image.asset("assets/images/avatar_icon.png"),
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(75.0),
                    child: Image.network(
                      widget.imageUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '${widget.username}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,),
                ),
                Text(
                  "${widget.user.email}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.groups_outlined),
            title: const Text('Operators'),
            onTap: () {
              Get.back();
              Get.to(
                () => OperatorsPage(),
                curve: Curves.easeOut,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: const Text('Chat'),
            onTap: () {
              Get.back();
              Get.to(
                () => ChatWithAdmin(),
                curve: Curves.easeOut,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.report_outlined),
            title: const Text('Reports'),
            onTap: () {
              Get.back();
              Get.to(
                () => AdminReports(),
                curve: Curves.easeOut,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long_sharp),
            title: const Text('Logs'),
            onTap: () {
              Get.back();
              Get.to(
                () => Logs(),
                curve: Curves.easeOut,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Get.back();
              Get.to(
                () => const AccountPage(),
                curve: Curves.easeOut,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () async {
              _authController.signOut();
            },
          ),
        ],
      ),
    );
  }
}
