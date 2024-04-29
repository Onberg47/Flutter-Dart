/*
 * @ author Stephanos B
 * 18/04/2024
 * 
 * https://api.oceandrivers.com/static/docs.html
 */

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

/// make global so they can be set by the 'MyAppState' class for the 'WeatherWidget' class
const String URL_LATEST =
    "https://api.oceandrivers.com/v1.0/getWeatherDisplay/campastilla/?period=latestdata";
const String URL_LATEST_HOUR =
    "https://api.oceandrivers.com/v1.0/getWeatherDisplay/campastilla/?period=latesthour";

///Stores data from weather API
///@param data - expects a json object from jsonDecode()
class WeatherData {
  double humidex = 0;
  double temperature = 0;
  double rain = 0;
  double longitude = 0, latitude = 0;
  double time_in_seconds = 0;
  String date_time = "void"; //
  bool isLatest = true;

  String rainRange = " - ";
  String temperatureRange = " - ";
  String humidexRange = " - ";

  WeatherData(final jsonData, bool isGetLatest) {
    isLatest = isGetLatest;
    if (isGetLatest) {
      humidex = jsonData['HUMIDEX'];
      temperature = jsonData['TEMPERATURE'];
      rain = jsonData['RAIN'];
      longitude = jsonData['LONGITUDE'];
      latitude = jsonData['LATITUDE'];
      time_in_seconds = jsonData['TIME'];
      // 'TIME_STRING' is located in a sub-array of 'TWS_GUST_MAX'
      final tmpTime = jsonData['TWS_GUST_MAX'];
      date_time = tmpTime['TIME_STRING'];
    } else {
      final data = jsonData['LATEST_DATA'];

      longitude = data['LONGITUDE'];
      latitude = data['LATITUDE'];
      time_in_seconds = data['TIME'];
      // 'TIME_STRING' is located in a sub-array of 'TWS_GUST_MAX'
      final tmpTime = data['TWS_GUST_MAX'];
      date_time = tmpTime['TIME_STRING'];

      ///
      final int n = int.parse(jsonData['length'].toString());

      humidexRange = FindMaxMin(jsonData['HUMIDITY'], n);
      temperatureRange = FindMaxMin(jsonData['TEMPERATURE'], n);
      rainRange = FindMaxMin(jsonData['RAIN'], n);
    } // else
  } // constructor

  /// /// gets() /// ///
  String get getHumidex {
    if (isLatest) {
      return humidex.toString();
    } else {
      return humidexRange;
    }
  }

  String get getTemperature {
    if (isLatest) {
      return temperature.toString();
    } else {
      return temperatureRange;
    }
  } // getTemperature

  String get getRain {
    if (isLatest) {
      return rain.toString();
    } else {
      return rainRange;
    }
  }

  String get getLongitude {
    return longitude.toString();
  }

  String get getLatitude {
    return latitude.toString();
  }

  String get getTimeInSeconds {
    return time_in_seconds.toString();
  }

  String get getDateTime {
    return date_time;
  }

  /// /// methods() /// ///

  /// returns a String of $min - $max from a given JSON array of <i>: <value>
  String FindMaxMin(final data, final int n) {
    double? min, max;

    List<double> tmpRange = [];
    {
      double tmp = 0;
      for (int i = 0; i < n; i++) {
        tmp = data[i.toString()];
        print("\ti: $i = $tmp"); // debug
        tmpRange.add(tmp);
      } // for i
    }

    for (int i = 0; i < n; i++) {
      if (min == null) {
        min = tmpRange[i];
        max = tmpRange[i];
      }
      if (tmpRange[i] > max!) {
        max = tmpRange[i];
      } else if (tmpRange[i] < min) {
        min = tmpRange[i];
      }
    } // for i

    return "$min - $max";
  } // FindMaxMin()

  @override
  String toString() {
    String strOut = "";
    strOut =
        ("HumidEx: $humidex\nTemperature: $temperature\nRain: $rain\nLongitude: $longitude\nLatitude: $latitude\nDate and Time: $date_time\n");
    return strOut;
  } // toString()
} // WeatherData

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    return MyAppState();
  }
} // MyApp

class MyAppState extends State<MyApp> {
  bool isGetLatest = true; // must be initialised

  final myButtonColor = const Color.fromRGBO(118, 53, 220, 1); // #7635dc
  final myBackgroundColor = const Color.fromRGBO(33, 43, 54, 1); // #212B36

//
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'API Card',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(elevation: 2),
        ),
        home: Scaffold(
            backgroundColor: myBackgroundColor,
            appBar: AppBar(
              title: const Text("Weather Card"),
            ),
            body: Row(children: [
              //row 0
              Flexible(
                  child: FractionallySizedBox(
                heightFactor: 1,
                widthFactor: 0.6,
                child: Column(children: [
                  // Column 0
                  Flexible(
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      heightFactor: 0.3,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myButtonColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4)),
                            onPressed: () {
                              setState(() {
                                isGetLatest = true;
                              });
                            },
                            child: const Text(
                              "Get Latest",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                              selectionColor: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  // Column 1
                  Flexible(
                    child: FractionallySizedBox(
                      widthFactor: 0.6,
                      heightFactor: 0.3,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: myButtonColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4)),
                            onPressed: () {
                              setState(() {
                                isGetLatest = false;
                              });
                            },
                            child: const Text(
                              "Get last Hour",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  )
                ] // childeren
                    ),
              )),
              //row 1
              Expanded(
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: weatherWidget(isGetLatest)))
            ] //Row childeren
                )));
  } // build()
} // MyAppState

///Handles displaying data of a WeatherData object
class weatherWidget extends StatelessWidget {
  late final bool isGetLatest;
  weatherWidget(this.isGetLatest, {super.key}); // fetches from the super

  final dio = Dio();

  /// Used to store the current instance of WeatherData from loadWeather()
  /// this is 'late' since it is uninitialised but "we" know that it will be initialised before it is used
  late WeatherData wData;

  /// Fetches data from the API and feeds it to WeatherData
  /// returns a Future<WeatherData> instance with the loaded data, sets 'wData' to the new instance
  Future<WeatherData> loadWeather(bool isGetLatest) async {
    late final URL;
    if (isGetLatest) {
      URL = URL_LATEST;
    } else {
      URL = URL_LATEST_HOUR;
    }
    try {
      print("\tPinging: $URL"); // debug
      final response = await dio
          .get(URL)
          .timeout(const Duration(seconds: 5)); //todo: fix timeout not working

      final data = jsonDecode(response.toString());
      WeatherData currentWeather = WeatherData(data, isGetLatest);
      print("\t\tweatherData toString:\n" + currentWeather.toString()); //debug
      wData = currentWeather;

      return currentWeather;
    } on DioException catch (e) {
      throw Exception("Error Recieving data:\n\t$e");
    }
  } //loadWeather()

  @override
  Widget build(BuildContext context) {
    final weather = loadWeather(isGetLatest);

    return FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Text(
                "Waiting...",
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              );

            case ConnectionState.done:
              if (snapshot.hasError) {
                return const Text(
                  "An error occured processing the data!",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                );
              } else {
                /// Simple toString foramt, mainly for debug
                /*
                return Text(
                  wData.toString(),
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.start,
                );
                */

                // Done to clean-up code inside the table
                const myTableTextStyle =
                    TextStyle(fontSize: 18, fontStyle: FontStyle.normal);

                return Table(
                  //border: TableBorder.all(width: 2.0, color: Colors.black26),
                  children: [
                    //TableRow 0
                    const TableRow(children: [
                      Text("HEADING",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      Text("DATA",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold))
                    ]),
                    //TableRow 1
                    TableRow(children: [
                      const Text("Humidity", style: myTableTextStyle),
                      Text(wData.getHumidex, style: myTableTextStyle)
                    ]),
                    //TableRow 2
                    TableRow(children: [
                      const Text("Temperature", style: myTableTextStyle),
                      Text(wData.getTemperature, style: myTableTextStyle)
                    ]),
                    //TableRow 3
                    TableRow(children: [
                      const Text("Rain", style: myTableTextStyle),
                      Text(wData.getRain, style: myTableTextStyle)
                    ]),
                    //TableRow 4
                    TableRow(children: [
                      const Text("Longitud", style: myTableTextStyle),
                      Text(wData.getLongitude, style: myTableTextStyle)
                    ]),
                    //TableRow 5
                    TableRow(children: [
                      const Text("Latitude", style: myTableTextStyle),
                      Text(wData.getLatitude, style: myTableTextStyle)
                    ]),
                    //TableRow 6
                    TableRow(children: [
                      const Text("Date and Time", style: myTableTextStyle),
                      Text(wData.getDateTime, style: myTableTextStyle)
                    ]),
                  ], // childeren
                );
              } //else

            default:
              return const Text(
                "No Data!",
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              );
          } // switch
        });
  } // build()
} // weatherWidget
