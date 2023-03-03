import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/authors_list.dart';


class EquipeTecnica extends StatefulWidget {
  const EquipeTecnica({Key? key}) : super(key: key);

  @override
  State<EquipeTecnica> createState() => _EquipeTecnicaState();
}

class _EquipeTecnicaState extends State<EquipeTecnica> {
  Future<void> _launchUrl(idx) async {
    // HttpOverrides.global = MyHttpOverrides();
    if (!await launchUrl(Authors.linkLattes[idx])) {
      throw 'Could not launch ${Authors.linkLattes[idx]}';
    }
  }

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
        title: const Text("Equipe Técnica"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: _list(context),
              ),
              const SizedBox(
                height: 56,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _list(BuildContext context) => Authors.names
      .map(
        (e) => Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  ListTile(
                    isThreeLine: true,
                    title: Text(
                      Authors.names[Authors.names.indexOf(e)],
                      style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Authors.educationalBackground[Authors.names.indexOf(e)],
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.openSans(fontSize: 16),
                        ),
                        Text(
                          Authors.job[Authors.names.indexOf(e)],
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.openSans(fontSize: 16),
                        ),
                        Column(
                          children: [
                            Text(
                              'Para mais informações acessar:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(fontSize: 16),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  side: const BorderSide(
                                    style: BorderStyle.none,
                                  ),
                                ),
                                onPressed: () {
                                  _launchUrl(Authors.names.indexOf(e));
                                },
                                child: Text(
                                  Authors.linkLattes[Authors.names.indexOf(e)].toString(),
                                  style: GoogleFonts.openSans(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      .toList();
}
