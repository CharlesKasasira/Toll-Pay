import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/controllers/auth_controllers.dart';
import 'package:tollpay/screens/account_page.dart';
import 'package:tollpay/screens/chat_page.dart';
import 'package:tollpay/screens/maps_page.dart';
import 'package:tollpay/screens/payment_page.dart';
import 'package:tollpay/utils/constants.dart';

class MyDrawer extends StatefulWidget {
  var user;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? username;
  MyDrawer(
      {this.user,
      this.imageUrl,
      this.firstName,
      this.lastName,
      this.username,
      Key? key})
      : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final AuthController _authController = AuthController();
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
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Make Payment'),
            onTap: () {
              Get.back();
              Get.to(
                () => PaymentPage(
                        user: widget.user,
                        firstName: widget.firstName,
                        lastName: widget.lastName),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Map'),
            onTap: () {
              Get.back();
              Get.to(
                () => MyMap(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.message_outlined),
            title: const Text('Chat'),
            onTap: () {
              Get.back();
              Get.to(
                () => const ChatPage(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
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
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
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
            }
          ),
        ],
      ),
    );
  }
}
