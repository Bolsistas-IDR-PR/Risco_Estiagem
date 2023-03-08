import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/authors_list.dart';

class EquipeTecnica extends StatelessWidget {
  const EquipeTecnica({Key? key}) : super(key: key);

  Future<void> _launchUrl(idx) async {
    // HttpOverrides.global = MyHttpOverrides();
    if (!await launchUrl(Authors.linkLattes[idx])) {
      throw 'Could not launch ${Authors.linkLattes[idx]}';
    }
  }
//
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: MediaQuery.of(context).orientation.name == 'landscape'
            ? const EdgeInsets.only(left: 40, right: 40, bottom: 8, top: 8)
            : const EdgeInsets.all(8),
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
