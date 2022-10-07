class Weather {
  var city,
      country,
      main,
      icon,
      description,
      temp,
      feelsLike,
      tempMin,
      tempMax,
      pressure,
      humidity,
      windspeed;

  Weather.getWeather(var json) {
    city = json['name'];
    country = json['sys']['country'];
    icon = json['weather'][0]['icon'];
    main = json['weather'][0]['main'];
    description = json['weather'][0]['description'];
    temp = json['main']['temp'].toStringAsFixed(0) + "°c";
    feelsLike = (json['main']['feels_like'] - 273.15).round().toString() + "°";
    tempMin = (json['main']['temp_min'] - 273.15).round().toString() + "°";
    tempMax = (json['main']['temp_max'] - 273.15).round().toString() + "°";
    pressure = json['main']['pressure'].toString() + " hPa";
    humidity = json['main']['humidity'].toString() + " %";
    windspeed = json['wind']['speed'].toString() + " m/s";
  }
}
