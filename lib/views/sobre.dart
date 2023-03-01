import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Sobre extends StatefulWidget {
  const Sobre({Key? key}) : super(key: key);

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 48,
        title: const Text("Sobre"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
    );
  }
}
