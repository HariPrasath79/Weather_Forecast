import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/components/additional_info.dart';
import 'package:weather_app/components/hourly_forcast_item.dart';

import 'package:http/http.dart' as http;

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWeather();
  }

  Future currentWeather() async {
    final res = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=eacb1563a910ec3bf942f284524ad036'));
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    print('build function called');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: const Column(
                        children: [
                          Text(
                            "300° F",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          Icon(
                            Icons.cloudy_snowing,
                            size: 56,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Rain',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 17),
            const Text(
              "Weather Forecast",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForcastItem(
                    icon: Icons.cloud,
                    time: "9:00",
                    fahrenheit: 301.1,
                  ),
                  HourlyForcastItem(
                      icon: Icons.cloud, time: "12:00", fahrenheit: 301.5),
                  HourlyForcastItem(
                      icon: Icons.cloud, time: "3:00", fahrenheit: 299.3),
                  HourlyForcastItem(
                      icon: Icons.cloud, time: "6:00", fahrenheit: 290.1),
                  HourlyForcastItem(
                      icon: Icons.cloud, time: "9:00", fahrenheit: 283.1),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Additional Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInformation(
                    icon: Icons.water_drop, parameter: 'Humidity', value: 94),
                AdditionalInformation(
                    icon: Icons.air, parameter: 'Wind Speed', value: 7.67),
                AdditionalInformation(
                    icon: Icons.beach_access_outlined,
                    parameter: 'Pressure',
                    value: 1006)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
