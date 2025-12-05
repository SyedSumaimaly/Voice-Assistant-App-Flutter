import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:voice_assistant_app/home_page.dart';
import 'package:voice_assistant_app/pallete.dart';

void main() {
  runApp(
      DevicePreview(
        enabled: true,
        builder: (context) => MyApp(),
      )
      // const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voice Assistant App',
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Pallete.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: Pallete.whiteColor,
        )
      ),
      home: const HomePage(),
    );
  }
}

