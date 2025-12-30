import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weathix/models/weather_model.dart';
import 'package:weathix/services/weather_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService(dotenv.env['OPENWEATHER_API_KEY']!);
  Weather? _weather;

  Future<void> _fetchWeather() async {
    //get city
    String cityName = await _weatherService.getCurrentCity();

    //get city weather
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetching weather data')),
        );
      }
    }
  }

  Color getBaseColor(bool? isDay) =>
      (isDay ?? true) ? Colors.white : Colors.grey.shade900;

  Color getTextColor(bool? isDay) =>
      (isDay ?? true) ? Colors.black : Colors.white;

  String getWeatherAnimation(String? mainCondition, bool? isDay) {
    if (mainCondition == null) {
      return isDay == false ? 'assets/clearNight.json' : 'assets/clearDay.json';
    }

    final day = isDay ?? true;

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return day ? 'assets/cloudyDay.json' : 'assets/cloudyNight.json';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
      case 'mist':
      case 'sand':
      case 'ash':
      case 'squall':
      case 'Tornado':
        return 'assets/mist.json';
      case 'rain':
      case 'drizzle':
        return day ? 'assets/rainyDay.json' : 'assets/rainyNight.json';
      case 'thunderstorm':
        return 'assets/storm.json';
      case 'snow':
        return 'assets/snow.json';
      case 'clear':
        return day ? 'assets/clearDay.json' : 'assets/clearNight.json';
      default:
        return day ? 'assets/clearDay.json' : 'assets/clearNight.json';
    }
  }

  @override
  void initState() {
    super.initState();

    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(_weather?.isDay);
    return Scaffold(
      backgroundColor: getBaseColor(_weather?.isDay),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //city
              Text(
                _weather?.cityName.toUpperCase() ?? "Loading city..",
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              //Animation
              LottieBuilder.asset(
                getWeatherAnimation(_weather?.mainCondition, _weather?.isDay),
              ),

              //temperature
              Text(
                '${_weather?.temperature.round()}°',
                style: TextStyle(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
