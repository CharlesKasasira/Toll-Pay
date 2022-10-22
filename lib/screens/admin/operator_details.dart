// ignore: unnecessary_import
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:tollpay/components/auth_required_state.dart';
import 'package:tollpay/controllers/user_controllers.dart';
import 'package:tollpay/screens/organisation/organisation_dashboard.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';

class OperatorDetails extends StatefulWidget {
  var id;
  OperatorDetails({Key? key, this.id}) : super(key: key);

  @override
  _OperatorDetailsState createState() => _OperatorDetailsState();
}

class _OperatorDetailsState extends AuthRequiredState<OperatorDetails> {
  String? _userId;
  String? _avatarUrl;
  String? username;

  Future getDriverDetails() async {
    final response =
        await supabase.from('profiles').select().eq('id', widget.id).execute();

    final data = response.data;
    final error = response.error;

    // print("inside");
    if (data != null) {
      username = data[0]["username"] as String;
    } else {}

    if (error != null) {
      print("the error is ${error.message}");
    }
    return data;
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    // _user = user;
    if (user != null) {
      _userId = user.id;
      getDriverDetails();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getDriverDetails();
    return Scaffold(
      backgroundColor: ColorConstants.kprimary,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: const Color.fromARGB(100, 158, 158, 158),
        backgroundColor: ksecondary,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Operator's Details",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            SizedBox(
              width: 10,
            ),
            AppBarAvatar()
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 30),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
            top: 8.0,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),
            children: [
              FutureBuilder(
                  future: getDriverDetails(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xff1a1a1a),
                          ),
                        );
                      default:
                        return snapshot.data == null
                            ? Container(
                                height: MediaQuery.of(context).size.height,
                                padding: const EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Icon(Icons.wifi_off_outlined),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Check your internet connection.",
                                        style: TextStyle(
                                            fontFamily: "Spartan",
                                            color:
                                                Color.fromARGB(255, 24, 24, 24),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : QRList(snapshot.data);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget QRList(location) {
  UserController _userController = UserController();
  print("location is $location");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          const Text("Name:"),
          const SizedBox(
            width: 5,
          ),
          Text("${location[0]["username"]}"),
        ],
      ),
      Row(
        children: [
          const Text("Role:"),
          const SizedBox(
            width: 5,
          ),
          Text("${location[0]["roles"]}"),
        ],
      ),
      Row(
        children: [
          const Text("Number:"),
          const SizedBox(
            width: 5,
          ),
          Text("${location[0]["phone"]}"),
        ],
      ),
      Row(
        children: [
          const Text("Email:"),
          const SizedBox(
            width: 5,
          ),
          Text("${location[0]["email"]}"),
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      CustomElevatedButton(
          onTap: () {
            kDefaultDialog(
                "Confirm", "Are you sure you want to delete this operator",
                onYesPressed: () {
              Get.back();
              _userController.deleteUser(
                  "${location[0]["id"]}", "${location[0]["username"]}","${location[0]["roles"]}");
            });
          },
          text: "Delete Operator")
    ],
  );
  // }
}
