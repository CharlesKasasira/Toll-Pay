import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tollpay/screens/organisation/drivers/driver_details.dart';
import 'package:tollpay/screens/qr_details.dart';
import 'package:tollpay/widgets/list_avatar.dart';

Widget logsList(location) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: (location as List<dynamic>).length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
            // leading: ListAvatar(
            //   avatar: location[index]['avatarUrl'],
            // ),
            title: Text(
              "${location[index]['description']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${location[index]['status']}"),
            onTap: () {
              Get.to(
                () => DriversDetails(id: location[index]['id']),
                transition: Transition.cupertino,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              );
            },
          ),
          Divider(thickness: 2,)
          ]
        );
      });
  // }
}
