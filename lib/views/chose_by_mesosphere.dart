import 'package:flutter/material.dart';

class Mesorregiao extends StatefulWidget {
  const Mesorregiao({Key? key}) : super(key: key);

  @override
  State<Mesorregiao> createState() => _MesorregiaoState();
}

class _MesorregiaoState extends State<Mesorregiao> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Seleção por Mesorregião'),
      ),
      body: Center(
        child: Image.asset('assets/assets_mesorregiao/mesorregiao.png'),
      ),
    );
  }
}

