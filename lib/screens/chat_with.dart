
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tollpay/screens/admin/add_operator.dart';
import 'package:tollpay/screens/admin/operator_details.dart';
import 'package:tollpay/screens/chat_page.dart';
import 'package:tollpay/utils/constants.dart';
import 'package:tollpay/utils/get_drivers.dart';
import 'package:tollpay/utils/get_operators.dart';
import 'package:tollpay/widgets/appbar_avatar.dart';
import 'package:tollpay/widgets/button.dart';
import 'package:tollpay/widgets/drivers_list.dart';
import 'package:tollpay/widgets/empty_widget.dart';
import 'package:tollpay/widgets/list_avatar.dart';
import 'package:tollpay/widgets/operators_list.dart';

class ChatWithAdmin extends StatefulWidget {

  ChatWithAdmin(
      {Key? key,})
      : super(key: key);

  @override
  State<ChatWithAdmin> createState() => _ChatWithAdminState();
}

class _ChatWithAdminState extends State<ChatWithAdmin> {
  bool isAndroid = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getOperatorsHere() async {
  final response = await supabase.from('profiles').select().eq("roles", "operator").execute();

  final data = response.data;
  final error = response.error;

  if (data != null) {
  } else {}

  if (error != null) {
    print("the error is ${error.message}");
  }
  print(data);
  return data;
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Scaffold(
        backgroundColor: const Color(0xffF6F6F6),
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
                "Chats",
              ),
              AppBarAvatar()
            ],
          ),
          leading: Builder(builder: (context) {
            return Container(
              width: 15,
              height: 15,
              margin: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            );
          }),
        ),
        body: SafeArea(
          // minimum: const EdgeInsets.only(top: 30),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              top: 8.0,
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              children: [
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                  future: getOperatorsHere(),
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
                            ? const Empty()
                            : MyOperators(snapshot.data);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget MyOperators(location) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: (location as List<dynamic>).length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 0,
          color: Colors.transparent,
          child: ListTile(
            leading: ListAvatar(
              avatar: location[index]['avatarUrl'],
            ),
            title: Text(
              "${location[index]['username']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${location[index]['roles']}"),
            onTap: () {
              Get.to(
                () => ChatPage(),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              );
            },
          ),
        );
      });
  // }
}

