import 'package:flutter/material.dart';
import 'package:get/get.dart';
class MediaRegional extends StatefulWidget {
  const MediaRegional({Key? key}) : super(key: key);

  @override
  State<MediaRegional> createState() => _MediaRegionalState();
}

class _MediaRegionalState extends State<MediaRegional> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.offAllNamed('/');
        }, icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 48,
        title: const Text("Média Regional"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
    );
  }
}
