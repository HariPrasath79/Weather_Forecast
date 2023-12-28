import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/components/additional_info.dart';
import 'package:weather_app/components/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/theme_provider.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String temp = '0';

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      const String cityName = 'sankari';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=eacb1563a910ec3bf942f284524ad036'),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw "An unexpected error occured";
      }

      return data;
    } catch (err) {
      throw err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themestate = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;

          final currentWeather = data['list'][0];

          double temp = currentWeather['main']['temp'];
          final currentSky = currentWeather['weather'][0]['main'];
          final currentPressure = currentWeather['main']['pressure'];
          final currentWindSpeed = currentWeather['wind']['speed'];
          final currentHumidity = currentWeather['main']['humidity'];

          temp = temp - 273.15;
          String curTemp = temp.toStringAsFixed(2);

          return Padding(
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
                          child: Column(
                            children: [
                              Text(
                                "$curTemp °C",
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? CupertinoIcons.cloud_fill
                                    : CupertinoIcons.sun_max_fill,
                                size: 56,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 17),
                const Text(
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                //Hourly forecasting Section_______________________________________________________

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyforecast = data['list'][index + 1];
                      final hourlyForecastTemp =
                          (hourlyforecast['main']['temp'] - 273.15);
                      final time = DateTime.parse(hourlyforecast['dt_txt']);
                      return HourlyForcastItem(
                        time: DateFormat.j().format(time),
                        temp: '${hourlyForecastTemp.toStringAsFixed(2)} °C',
                        icon: currentSky == 'Clouds' || currentSky == 'Rain'
                            ? CupertinoIcons.cloud_fill
                            : CupertinoIcons.sun_max_fill,
                      );
                    },
                  ),
                ),

                //Additional Information Section____________________________________________________
                const SizedBox(height: 16),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformation(
                        icon: Icons.water_drop,
                        parameter: 'Humidity',
                        value: currentHumidity.toString()),
                    AdditionalInformation(
                        icon: CupertinoIcons.wind,
                        parameter: 'Wind Speed',
                        value: currentWindSpeed.toString()),
                    AdditionalInformation(
                      icon: CupertinoIcons.speedometer,
                      parameter: 'Pressure',
                      value: currentPressure.toString(),
                    )
                  ],
                ),

                const SizedBox(height: 30),

                SwitchListTile(
                  title: const Text("Theme"),
                  secondary: Icon(themestate.getDarktheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    themestate.setDarkTheme = value;
                  },
                  value: themestate.getDarktheme,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
