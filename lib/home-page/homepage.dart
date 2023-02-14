import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late GoogleMapController mapController;

final LatLng _center = const LatLng(-23.2927, -51.1732);

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("estiagem"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
                ),
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 5.5
                  ),
                ),
              ),
              TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.saved_search),
                      hintText: 'Informe o nome')),
            ],
          ),
        ));
  }
}
