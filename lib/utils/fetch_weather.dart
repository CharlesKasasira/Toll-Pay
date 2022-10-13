import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tollpay/models/weather.dart';

Future fetchWeather() async {
  final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=Entebbe&units=metric&appid=${dotenv.env['WEATHER_API_KEY']}");
  final http.Response response = await http.get(url);
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Weather.getWeather(json);
  } else {
    return null;
  }
}
