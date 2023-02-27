import 'package:estiagem/views/ajuda.dart';
import 'package:estiagem/views/equipe_tecnica.dart';
import 'package:estiagem/views/introducao.dart';
import 'package:estiagem/views/media_regional.dart';
import 'package:estiagem/views/metodologia.dart';
import 'package:estiagem/views/sobre.dart';
import 'package:flutter/material.dart';
import 'package:estiagem/home-page/homepage.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(
    GetMaterialApp(
      routes: {
        '/introducao': (context) => const Introducao(),
        '/metodologia': (context) => const Metodologia(),
        '/media_regional': (context) => const MediaRegional(),
        '/sobre': (context) => const Sobre(),
        '/equipe_tecnica': (context) => const EquipeTecnica(),
        '/ajuda': (context) => const Ajuda(),
      },
      debugShowCheckedModeBanner: false,
      home: const MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
//home:const HomePage(),debugShowCheckedModeBanner: false,)
