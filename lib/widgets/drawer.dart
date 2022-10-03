import 'package:flutter/material.dart';
import 'package:ysave/components/avatar.dart';
import 'package:supabase/supabase.dart';
import 'package:ysave/components/auth_required_state.dart';
import 'package:ysave/pages/account_page.dart';
import 'package:ysave/pages/maps_page.dart';
import 'package:ysave/pages/payment_page.dart';
import 'package:ysave/utils/constants.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

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
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                if (_avatarUrl == null || _avatarUrl!.isEmpty)
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: Colors.grey,
                    ),
                  )
                else
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: NetworkImage(_avatarUrl!)),
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      color: Colors.grey,
                    ),
                  ),
                Text(
                  '${_firstNameController.text}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('QR Scanner'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyMap()),
              );
            },
          ),
          ListTile(
            title: const Text('Map'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyMap()),
              );
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Log Out'),
            onTap: ()async {
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
