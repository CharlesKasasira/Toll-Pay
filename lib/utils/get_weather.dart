import 'package:flutter/material.dart';
import 'package:tollpay/utils/color_constants.dart';
Widget getWeather(location) {

  return Container(
    // height: 180,
    padding: const EdgeInsets.all(10),
    alignment: Alignment.center,
    // width: MediaQuery.of().size.width,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 3,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),

    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
          "${location.temp}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorConstants.ksecondary,
            fontSize: 20
          ),
        ),
        const SizedBox(width: 2,),
            Image.network(
              "http://openweathermap.org/img/wn/${location.icon}@2x.png",
              width: 50,
            ),
              ],
            ),
            
            Text(
              "${location.description}",
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
            const SizedBox(
          width: 10,
        ),
        
        const SizedBox(
          height: 5,
        ),
        const Text(
          "ENTEBBE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
          ],
        ),
        
        
  );
}