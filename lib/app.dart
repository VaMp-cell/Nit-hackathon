import 'package:flutter/material.dart';
import 'routes.dart';

class CityPulseApp extends StatelessWidget {
  const CityPulseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CityPulse (Mock)',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
