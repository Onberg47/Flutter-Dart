/*
 * @author Stephanos B
 */

import 'package:flutter/material.dart';
import 'package:flutter_application_1/homePage.dart';

import 'package:dio/dio.dart';
import 'dart:convert';

class WeatherData {
  double humidex = 0;
  double temperature = 0;
  double rain = 0;
  double longitude = 0, latitude = 0;
  double time_in_seconds = 0, time = 0;

  WeatherData(final data) {
    humidex = data['HUMIDEX'];
    temperature = data['TEMPERATURE'];
    rain = data['RAIN'];
    longitude = data['LONGITUDE'];
    latitude = data['LATITUDE'];
    time_in_seconds = data['TIME'];

    time = time_in_seconds; //todo
  } // constructor

  /// /// gets() /// ///
  String get getHumidex {
    return humidex.toString();
  }

  String get getTemperature {
    return temperature.toString();
  }

  String get getRain {
    return rain.toString();
  }

  String get getLongitude {
    return longitude.toString();
  }

  String get getLatitude {
    return latitude.toString();
  }

  String get getTime {
    return time.toString();
  }

  /// /// methods() /// ///
  @override
  String toString() {
    String strOut = "";
    strOut =
        ("HumidEx: $humidex\nTemperature: $temperature\nRain: $rain\nLongitude: $longitude\nLatitude: $latitude\nTime: $time");
    return strOut;
  }
} // WeatherData

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key}) {}

  final String URL_LATEST =
      "https://api.oceandrivers.com/v1.0/getWeatherDisplay/campastilla/?period=latestdata";
  final String URL_LATEST_HOUR =
      "https://api.oceandrivers.com/v1.0/getWeatherDisplay/campastilla/?period=latesthour";

  final dio = Dio();
  WeatherData? wData;

  Future<WeatherData> loadWeather(String URL) async {
    try {
      final response = await dio
          .get(URL)
          .timeout(const Duration(seconds: 5)); //todo: fix timeout not working

      final data = jsonDecode(response.toString());
      WeatherData currentWeather = WeatherData(data);
      print(currentWeather.toString()); //debug

      wData = currentWeather;

      return currentWeather;
    } on DioException catch (e) {
      throw Exception("Error:\n\t$e");
    }
  } //loadWeather()

  @override
  Widget build(BuildContext context) {
    var weather;
    //weather = loadWeather();
    return Scaffold(
        body: Row(
      children: [
        //row 0
        Column(children: [
          const Text("Time periodes: "),
          ElevatedButton(
              onPressed: () {
                weather = loadWeather(URL_LATEST);
              },
              child: const Text("Get Latest")),
          ElevatedButton(
              onPressed: () {
                weather = loadWeather(URL_LATEST_HOUR);
              },
              child: const Text("Get last Hour"))
        ] // childeren
            ),
        //row 1
        Column(
          children: [
            const Text("Data: "),
            FutureBuilder(
                future: weather,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text("Waiting...");

                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return const Text("An error occured fetching the data");
                      } else {
                        return Text(wData!.toString());
                      }

                    default:
                      return const Text("No Data");
                  } // switch
                })
          ],
        ),
      ],
    ));
  } // build

  toHome(context) {
    print("\t# Going Home"); //debug
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyHomePage()));
  } //toHome()
}// MyHomePage