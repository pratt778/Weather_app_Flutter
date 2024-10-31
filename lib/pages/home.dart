import 'package:flutter/material.dart';
import 'package:weather_app_flutter/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  String _city = "Kathmandu";
  Map<String, dynamic>? _currentWeather;

  @override
  void initState() {
    super.initState();
    FetchWeatherData();
  }

  Future<void> FetchWeatherData() async {
    try {
      final _weatherData = await _weatherService.fetchWeather(_city);
      setState(() {
        _currentWeather = _weatherData;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentWeather == null
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blue],
                      begin: Alignment.bottomCenter,
                      end: Alignment.bottomRight)),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlue, Colors.blue],
                      begin: Alignment.bottomCenter,
                      end: Alignment.bottomRight)),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _city,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.network(
                        'http:${_currentWeather?['current']['condition']['icon']}'),
                  )
                ],
              ),
            ),
    );
  }
}
