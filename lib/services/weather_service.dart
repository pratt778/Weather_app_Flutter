import "dart:convert";

import "package:http/http.dart" as http;

class WeatherService {
  final String apiKey = "898819d74def4902b68124252243010";
  final String apiUrl = "https://api.weatherapi.com/v1/forecast.json";
  final String apiSearch = "http://api.weatherapi.com/v1/search.json";

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = '$apiUrl?key=$apiKey&q=$city&day=1&aqi=no&alert=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather");
    }
  }

//  http://api.weatherapi.com/v1/forecast.json?key=<YOUR_API_KEY>&q=07112&days=7
  Future<Map<String, dynamic>> fetch7daysWeather(String city) async {
    final url = '$apiUrl?key=$apiKey&q=$city&days=7&aqi=no&alert=no';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather");
    }
  }
}
