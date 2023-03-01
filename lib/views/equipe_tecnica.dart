import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
class EquipeTecnica extends StatefulWidget {
  const EquipeTecnica({Key? key}) : super(key: key);

  @override
  State<EquipeTecnica> createState() => _EquipeTecnicaState();
}

class _EquipeTecnicaState extends State<EquipeTecnica> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 48,
        title: const Text("Equipe Técnica"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
    );
  }
}
