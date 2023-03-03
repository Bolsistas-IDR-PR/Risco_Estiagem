import 'package:estiagem_parana/views/ajuda.dart';
import 'package:estiagem_parana/views/equipe_tecnica.dart';
import 'package:estiagem_parana/views/introducao.dart';
import 'package:estiagem_parana/views/media_regional.dart';
import 'package:estiagem_parana/views/metodologia.dart';
import 'package:estiagem_parana/views/sobre.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'home-page/homepage.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/introducao': (context) => const Introducao(),
        '/metodologia': (context) => const Metodologia(),
        '/media_regional': (context) => const MediaRegional(),
        '/sobre': (context) => const Sobre(),
        '/equipe_tecnica': (context) => const EquipeTecnica(),
        '/ajuda': (context) => const Ajuda(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}
// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }
