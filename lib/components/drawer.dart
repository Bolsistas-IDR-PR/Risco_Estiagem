import 'package:flutter/material.dart';

class DrawerBuild extends StatelessWidget {
  final Function setScreen;
  final int idx;
  const DrawerBuild(this.setScreen, {super.key, required this.idx});
  final Color _colorSelected = const Color.fromRGBO(197, 197, 197, 1);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          child: Image.asset(
            'assets/assets_drawer/Logo_IDR.png',
            fit: BoxFit.contain,
          ),
        ),
        ListTile(
            tileColor: idx == 0 ? _colorSelected : null,
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              setScreen(0);
              Navigator.pop(context);
            }),
        ListTile(
            leading: const Icon(Icons.phone_android_outlined),
            tileColor: idx == 1 ? _colorSelected : null,
            title: const Text('Apresentação'),
            onTap: () {
              setScreen(1);
              Navigator.pop(context);
            }),
        ListTile(
          leading: const Icon(Icons.settings_suggest_outlined),
          tileColor: idx == 2 ? _colorSelected : null,
          title: const Text('Metodologia'),
          onTap: () {
            setScreen(2);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.show_chart),
          tileColor: idx == 3 ? _colorSelected : null,
          title: const Text('Média Regional de Estiagem'),
          onTap: () {
            setScreen(3);
            Navigator.pop(context);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          tileColor: idx == 4 ? _colorSelected : null,
          title: const Text('Sobre'),
          onTap: () {
            setScreen(4);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person_outline_outlined),
          tileColor: idx == 5 ? _colorSelected : null,
          title: const Text('Equipe Técnica'),
          onTap: () {
            setScreen(5);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
