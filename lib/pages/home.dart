import 'package:flutter/material.dart';
import 'package:weather_app_flutter/pages/forecast.dart';
import 'package:weather_app_flutter/services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final TextEditingController _controller = TextEditingController();
  String _city = "Kathmandu";
  Map<String, dynamic>? _currentWeather;

  @override
  void initState() {
    super.initState();
    FetchWeatherData();
  }

  void showCityDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Enter a city Name"),
            content: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    if (_controller.text != '') {
                      setState(() {
                        _city = _controller.text;
                      });
                      Navigator.pop(context);
                      _controller.text = "";
                      FetchWeatherData();
                    }
                  },
                  child: Text("Submit")),
            ],
          );
        });
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
                      colors: [Colors.green, Colors.blue],
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
                      colors: [Colors.green, Colors.blue],
                      begin: Alignment.topCenter,
                      end: Alignment.center)),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => showCityDialog(),
                    child: Text(
                      _city,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.network(
                      'http:${_currentWeather?['current']['condition']['icon']}',
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Text(
                      (_currentWeather?["current"]["temp_c"]).toString() +
                          " °C",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _currentWeather?["current"]["condition"]["text"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Max: ${_currentWeather?["forecast"]["forecastday"][0]["day"]["maxtemp_c"]} °C',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                          'Min: ${_currentWeather?["forecast"]["forecastday"][0]["day"]["mintemp_c"]} °C',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildWeatherBox("Sunrise", Icons.sunny,
                          "${_currentWeather?["forecast"]["forecastday"][0]["astro"]["sunrise"]}"),
                      buildWeatherBox("Sunset", Icons.brightness_3,
                          "${_currentWeather?["forecast"]["forecastday"][0]["astro"]["sunset"]}"),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildWeatherBox("Humidity", Icons.water_drop,
                          "${_currentWeather?['forecast']['forecastday'][0]['day']['avghumidity']}"),
                      buildWeatherBox("Windspeed", Icons.air,
                          "${_currentWeather?["current"]["wind_kph"]}")
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ForecastScreen(city: _city)));
                    },
                    child: Text("7-days Forecast"),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildWeatherBox(String label, IconData icon, String data) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.blue[600],
        width: 130,
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            Icon(
              icon,
              color: Colors.white38,
            ),
            Text(
              data,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }
}
