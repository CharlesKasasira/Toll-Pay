class Weather {
  var city, country, main, icon, description, temp;

  Weather.getWeather(var json) {
    city = json['name'];
    country = json['sys']['country'];
    icon = json['weather'][0]['icon'];
    main = json['weather'][0]['main'];
    description = json['weather'][0]['description'];
    temp = json['main']['temp'].toStringAsFixed(0) + "°c";
  }
}
