import 'package:flutter/material.dart';
import 'package:tollpay/utils/color_constants.dart';
import 'package:tollpay/utils/constants.dart';

Widget getWeather(location) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${location.temp}",
                style: kNunitoSansSemiBold18.copyWith(
                    color: ksecondary, fontWeight: FontWeight.w700),
              ),
              Text(
                "${location.description}",
              ),
            ],
          ),
          const SizedBox(
            width: 2,
          ),
          Image.network(
            "http://openweathermap.org/img/wn/${location.icon}@2x.png",
            width: 50,
          ),
        ],
      ),
    ],
  );
}
