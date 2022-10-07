import 'package:flutter/material.dart';
import 'package:ysave/components/avatar.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_required_state.dart';
import 'package:ysave/pages/account_page.dart';
import 'package:ysave/pages/maps_page.dart';
import 'package:ysave/pages/payment_page.dart';
import 'package:ysave/pages/scan_qr.dart';
import 'package:ysave/utils/constants.dart';

class MyDrawer extends StatefulWidget {
  var user;
  String? imageUrl;
  String? firstName;
  String? lastName;
  MyDrawer({this.user, this.imageUrl, this.firstName, this.lastName, Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
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
    print("image is ${widget.imageUrl}");
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
                  Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: Color(0xffF5F5F5),
                    ),
                    child: const Text(
                      "C",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1a1a1a),
                          fontSize: 30),
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
                  '${widget.firstName} ${widget.lastName}',
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
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Make Payment'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentPage(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code_scanner_outlined),
            title: const Text('QR Scanner'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ScanPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Map'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyMap()),
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
            thickness: 3,
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () async {
              final response = await supabase.auth.signOut();
              final error = response.error;
              if (error != null) {
                context.showErrorSnackBar(message: error.message);
              }
            },
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
