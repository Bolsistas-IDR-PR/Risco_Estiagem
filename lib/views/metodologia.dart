import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Metodologia extends StatelessWidget {
  const Metodologia({Key? key}) : super(key: key);

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
                '   Foram utilizados dados de precipitação pluviométrica das estações meteorológicas'
                ' e postos pluviométricos do Instituto de Desenvolvimento Rural do Paraná – IAPAR-EMATER (IDR-Paraná),'
                ' do Instituto Água e Terra (IAT) e do Sistema de Tecnologia e Monitoramento Ambiental do Paraná (SIMEPAR).'
                ' Apenas os registros de dados superiores a 30 anos foram utilizados. O preenchimento das falhas pontuais'
                ' foi realizado buscando dados em estações mais próximas, em um raio máximo de 100 km. Utilizou-se do'
                ' software PostgreSQL para requisição dos dados e do framework Flutter para desenvolvimento do aplicativo.'
                ' A estimativa percentual do risco, para a escala temporal decendial (10 dias),'
                ' foi obtida através da frequência de eventos de estiagem em relação ao maior período'
                ' de dados das estações alocadas em cada município paranaense.',
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
