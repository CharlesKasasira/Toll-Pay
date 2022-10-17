import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tollpay/screens/qr_details.dart';

Widget driversList(location) {
  return ListView.builder(
      shrinkWrap: true,
      itemCount: (location as List<dynamic>).length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4,
          child: ListTile(
            leading: const Icon(Icons.qr_code),
            trailing: Text(
              "${location[index]['status']}",
              style: TextStyle(color: location[index]['status'] == 'Active' ? Colors.green : Colors.red, fontSize: 15),
            ),
            title: Text(
              "${location[index]['amount']}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${Jiffy(location[index]['created_at']).yMMMMd}"),
            onTap: () {
              Get.off(
                () => QRDetails(id: location[index]['id']),
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