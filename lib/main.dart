import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadir/views/visit/visit_page.dart';

import 'views/location/location_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hadir App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const VisitPage(),
    );
  }
}
