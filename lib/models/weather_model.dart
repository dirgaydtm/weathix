class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final bool isDay;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.isDay,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final dt = json['dt'];
    final sunrise = json['sys']['sunrise'];
    final sunset = json['sys']['sunset'];

    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      isDay: dt >= sunrise && dt < sunset,
    );
  }
}
