import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/components/avatar.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/pages/account_page.dart';
import 'package:tollpay/pages/chat_page.dart';
import 'package:tollpay/pages/maps_page.dart';
import 'package:tollpay/pages/payment_page.dart';
import 'package:tollpay/pages/scan_qr.dart';
import 'package:tollpay/utils/constants.dart';

class OperatorDrawer extends StatefulWidget {
  var user;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? username;
  OperatorDrawer(
      {this.user,
      this.imageUrl,
      this.firstName,
      this.lastName,
      this.username,
      Key? key})
      : super(key: key);

  @override
  State<OperatorDrawer> createState() => _OperatorDrawerState();
}

class _OperatorDrawerState extends State<OperatorDrawer> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  String? _userId;
  String? _avatarUrl;
  var _loading = false;

  void _goToScan() {
    Get.off(
      () => ScanPage(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
    );
  }

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
    // if (error != null && response.status != 406) {
    //   context.showErrorSnackBar(message: error.message);
    // }
    final data = response.data;
    if (data != null) {
      _firstNameController.text = (data['first_name'] ?? '') as String;
      print(data['first_name']);
      _lastNameController.text = (data['last_name'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    }
    print(data);
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
            decoration: BoxDecoration(
              color: Color(0xff1A1A1A),
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
                      fontSize: 17),
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
            leading: const Icon(Icons.qr_code_scanner_outlined),
            title: const Text('QR Scanner'),
            onTap: () {
              _goToScan();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
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
              final response = await supabase.auth.signOut();
              final error = response.error;
              if (error != null) {
                context.showErrorSnackBar(message: error.message);
              }
            },
          ),
        ],
      ),
    );
  }
}
