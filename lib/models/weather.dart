class Weather {
  var city,
      country,
      description,
      temp,
      feelsLike,
      tempMin,
      tempMax,
      pressure,
      humidity,
      windspeed;

  Weather.getWeather(var json) {
    country = json['location']['country'];
    // city = json['name'];
    // description = json['weather'][0]['main'];
    // temp = (json['main']['temp'] - 273.15).round().toString() + "°";
    // feelsLike = (json['main']['feels_like'] - 273.15).round().toString() + "°";
    // tempMin = (json['main']['temp_min'] - 273.15).round().toString() + "°";
    // tempMax = (json['main']['temp_max'] - 273.15).round().toString() + "°";
    // pressure = json['main']['pressure'].toString() + " hPa";
    // humidity = json['main']['humidity'].toString() + " %";
    // windspeed = json['wind']['speed'].toString() + " m/s";
  }
}
