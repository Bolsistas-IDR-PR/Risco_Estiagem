import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
        backgroundColor: Colors.green,
        leading: IconButton(
            onPressed: () {
             Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        toolbarHeight: 48,
        title: const Text("Sobre"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
         ListTile(
              title: Text(
                'InfoApp',
                style: GoogleFonts.openSans(),
              ),
              leading: const Icon(Icons.info_outline),
              trailing: Text('Versão: 1.0', style: GoogleFonts.openSans(),),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                openIDR();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 81,
                      width: 150,
                      child: Image.asset(
                        'assets/assets_drawer/Logo_IDR.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text('Conheça o IDR-Paraná',style: GoogleFonts.openSans(),),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                openYoutube();
              },

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 81,
                      width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/assets_sobre/icon_youtube.png',
                            width: 130,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'IDR-Paraná no Youtube',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                 Text(
                    'Atenção',
                    style: GoogleFonts.openSans(fontSize: 18),
                  ),
                  const SizedBox.square(
                    dimension: 15,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'O aplicativo é um produto desenvolvido pela área de agrometeorologia do IDR-Paraná.\n\n'
                      'Dúvidas e informações entre em contato através de idrparana@idr.pr.gov.br ',
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.openSans(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openIDR() async {
  final Uri url = Uri.parse('https://www.idrparana.pr.gov.br');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    /// Não è possível abrir a URL
  }
}

Future<void> openYoutube() async {
  final Uri url = Uri.parse('https://www.youtube.com/c/IDRParan%C3%A1/featured');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    /// Não è possível abrir a URL
  }
}
