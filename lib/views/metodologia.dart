import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
              Get.back();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:  [
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'O aplicativo foi desenvolvido para oferecer uma visão estatística sobre o risco de estiagem nos municípios do Paraná.'
                      ' Os dados foram obtidos através da base de dados das seguintes instituições: Instituto Água e Terra, '
                      'Instituito de Desenvolvimento Rural do Paraná - IAPAR - EMATER e SIMEPAR.\n\n'
                      'Todos os dados coletados foram selecionados pelos seguintes critérios: Período acima de 30 anos de dados e estações de confiabilidade.\n\n'
                      'O software utilizado para requisitar os dados do DB e manipulá-los foi o PostgreSQL. Os dados foram exportados como um arquivo de '
                      'formato CSV e este importado para o '
                      'ambiente de desenvolvimento. Foi utilizado o framework Flutter para desenvolver o aplicativo móvel.'
                      ,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.openSans(fontSize: 16),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
