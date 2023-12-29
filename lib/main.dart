import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/theme.dart';
import 'package:weather_app/theme_provider.dart';
import 'package:weather_app/weather.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        })
      ],
      child:
          Consumer<DarkThemeProvider>(builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: Styles.isDarkTheme(themeProvider.getDarktheme),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          home: const WeatherApp(),
        );
      }),
    );
  }
}
