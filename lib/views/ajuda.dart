import 'package:flutter/material.dart';

class Ajuda extends StatefulWidget {
  const Ajuda({Key? key}) : super(key: key);

  @override
  State<Ajuda> createState() => _AjudaState();
}

class _AjudaState extends State<Ajuda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 48,
        title: const Text("Ajuda"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
    );
  }
}
