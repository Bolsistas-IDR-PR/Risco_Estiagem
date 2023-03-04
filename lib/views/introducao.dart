import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Introducao extends StatelessWidget {
  const Introducao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: MediaQuery.of(context).orientation.name == 'landscape'
            ? const EdgeInsets.only(left: 40, right: 40, bottom: 8, top: 8)
            : const EdgeInsets.all(8),
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
    );
  }
}
