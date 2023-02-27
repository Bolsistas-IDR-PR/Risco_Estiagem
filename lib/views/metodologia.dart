import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Metodologia extends StatefulWidget {
  const Metodologia({Key? key}) : super(key: key);

  @override
  State<Metodologia> createState() => _MetodologiaState();
}

class _MetodologiaState extends State<Metodologia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed('/');
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 48,
        title: const Text("Metodologia"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
    );
  }
}
