import 'package:flutter/material.dart';
import 'package:estiagem/home-page/homepage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(home:HomePage(),debugShowCheckedModeBanner: false,)
    ),
  );
}
