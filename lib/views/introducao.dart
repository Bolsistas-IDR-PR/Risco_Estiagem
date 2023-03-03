import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Introducao extends StatefulWidget {
  const Introducao({Key? key}) : super(key: key);

  @override
  State<Introducao> createState() => _IntroducaoState();
}

class _IntroducaoState extends State<Introducao> {
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
        title: const Text("Apresentação"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  '   O aplicativo “Estiagem Paraná” tem como objetivo informar o risco de ocorrência'
                  ' de estiagem em diversos municípios do estado do Paraná, afim de subsidiar'
                  ' o planejamento das atividades agrícolas visando a redução dos riscos climáticos.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.openSans(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
