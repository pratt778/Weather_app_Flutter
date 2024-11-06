import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app_flutter/services/weather_service.dart';

class ForecastScreen extends StatefulWidget {
  final String city;

  ForecastScreen({super.key, required this.city});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  WeatherService _weatherService = WeatherService();

  List<dynamic>? current7weather;

  void initState() {
    super.initState();
    fetch7daysWeather();
  }

  Future<void> fetch7daysWeather() async {
    final weather7data = await _weatherService.fetch7daysWeather(widget.city);
    setState(() {
      current7weather = weather7data['forecast']['forecastday'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("7-Days forecast"),
        ),
        body: current7weather == null
            ? Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Colors.purple, Colors.deepOrange],
                  begin: Alignment.center,
                  end: Alignment.bottomLeft,
                )),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepOrange],
                    begin: Alignment.center,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: ListView.builder(
                  itemCount: current7weather?.length,
                  itemBuilder: (context, index) {
                    final forecastdata = current7weather?[index];
                    String icon =
                        "http:${forecastdata["day"]["condition"]["icon"]}";
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 4),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.center,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.black12, Colors.black38])),
                            child: ListTile(
                              leading: Image.network(icon),
                              title: Text(
                                forecastdata["date"],
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: Text(
                                  style: TextStyle(color: Colors.white54),
                                  "Max: ${forecastdata["day"]["maxtemp_c"]}\nMin: ${forecastdata["day"]["mintemp_c"]}"),
                              subtitle: Text(
                                  style: TextStyle(color: Colors.white60),
                                  forecastdata["day"]["condition"]["text"]),
                            ),
                          ),
                        ),
                      ),
                    );
                  },

                  // children: [
                  //   SizedBox(
                  //     height: 20,
                  //   ),
                  //   ForecastList(
                  //       wicon: current7weather?["forecast"]["forecastday"][0]
                  //           ["day"]["condition"]["icon"]),
                  //   Text(current7weather.toString())
                  // ],
                )));
  }
}
