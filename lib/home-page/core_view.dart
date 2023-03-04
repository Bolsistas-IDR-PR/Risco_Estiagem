import 'package:estiagem_parana/components/drawer.dart';
import 'package:estiagem_parana/home-page/homepage.dart';
import 'package:flutter/material.dart';
import '../views/equipe_tecnica.dart';
import '../views/introducao.dart';
import '../views/media_regional.dart';
import '../views/metodologia.dart';
import '../views/sobre.dart';

class CoreView extends StatefulWidget {
  const CoreView({Key? key}) : super(key: key);

  @override
  State<CoreView> createState() => _CoreViewState();
}

class _CoreViewState extends State<CoreView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentScreen = 0;
  final List<Widget> _screen = [
    const HomePage(),
    const Introducao(),
    const Metodologia(),
    const MediaRegional(),
    const Sobre(),
    const EquipeTecnica()
  ];
  final List<String> _title = [
    'Risco Estiagem Paraná',
    'Apresentação',
    'Metodologia',
    'Média Regional de Estiagem',
    'Sobre',
    'Equipe Técnica'
  ];
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _setScreen(int idx) {
    setState(
      () {
        _currentScreen = idx;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        toolbarHeight: 48,
        title: Text(_title[_currentScreen]),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
      drawer: Drawer(
        child: DrawerBuild(_setScreen, idx: _currentScreen),
      ),
      body: _screen[_currentScreen],
    );
  }
}
