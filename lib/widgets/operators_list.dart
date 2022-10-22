import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tollpay/screens/admin/operator_details.dart';
import 'package:tollpay/screens/organisation/drivers/driver_details.dart';
import 'package:tollpay/screens/qr_details.dart';
import 'package:tollpay/widgets/list_avatar.dart';

Widget operatorsList(location) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: (location as List<dynamic>).length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 1,
          child: ListTile(
            leading: ListAvatar(
              avatar: location[index]['avatarUrl'],
            ),
            title: Text(
              "${location[index]['username']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${location[index]['phone']}"),
            onTap: () {
              Get.to(
                () => OperatorDetails(id: location[index]['id']),
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
