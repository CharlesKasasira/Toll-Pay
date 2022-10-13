import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/components/avatar.dart';
import 'package:tollpay/pages/home_page.dart';
import 'package:tollpay/pages/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/constants.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends AuthRequiredState<AccountPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPhone = FocusNode();
  String? _userId;
  String? _avatarUrl;
  var _loading = false;

  /// Called once a user id is received within `onAuthenticated()`
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
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data;
    if (data != null) {
      _fullNameController.text = (data['username'] ?? '') as String;
      _emailController.text = (data['email'] ?? '') as String;
      _phoneController.text = (data['phone'] ?? '') as String;
      _avatarUrl = (data['avatar_url'] ?? '') as String;
    }
    setState(() {
      _loading = false;
    });
  }

  /// Called when user taps `Update` button
  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });
    final fullName = _fullNameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;
    final user = supabase.auth.currentUser;
    final updates = {
      'id': user!.id,
      'username': fullName,
      'email': email,
      'phone': phone,
      'updated_at': DateTime.now().toIso8601String(),
    };
    final response = await supabase.from('profiles').upsert(updates).execute();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Successfully updated profile!');
    }
    setState(() {
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    final response = await supabase.from('profiles').upsert({
      'id': _userId,
      'avatar_url': imageUrl,
    }).execute();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
    setState(() {
      _avatarUrl = imageUrl;
    });
    context.showSnackBar(message: 'Updated your profile image!');
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _userId = user.id;
      _getProfile(user.id);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPhone.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: Color(0xff1a1a1a),
          elevation: 0,
          foregroundColor: Colors.white,
          title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              width: 10,
            ),
            if (_avatarUrl == null || _avatarUrl!.isEmpty)
              ClipRRect(
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
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(75.0),
                child: Image.network(
                  _avatarUrl!,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
          leading: Builder(builder: (context) {
            return Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back,),
                onPressed: () {
                  Get.off(
                    () => const OrganisationHomePage(),
                    transition: Transition.cupertino,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  );
                },
              ),
            );
          }),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          children: [
            Avatar(
              imageUrl: _avatarUrl,
              onUpload: _onUpload,
            ),
            const SizedBox(height: 18),
            const Text(
              "Personal Information",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 5,),
                TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 144, 142, 142)),
                  controller: _fullNameController,
                  focusNode: _focusName,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Full Name',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 5,),
                TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 144, 142, 142)),
                  controller: _emailController,
                  focusNode: _focusEmail,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Enter email',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 5,),
                TextFormField(
                  style: TextStyle(color: Color.fromARGB(255, 144, 142, 142)),
                  controller: _phoneController,
                  focusNode: _focusPhone,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Phone Number',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ElevatedButton(
                onPressed: _updateProfile,
                child: Text(_loading ? 'Saving...' : 'Update')),
            const SizedBox(height: 5),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 249, 194, 194),
                  elevation: 0,
                ),
                onPressed: _updateProfile,
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Color(0xffE71111),),
                    SizedBox(
                      width: 8,
                    ),
                    Text("Delete Account", style: TextStyle(color: Color(0xffE71111)),)
                  ],
                )),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
