import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../repository/city_names.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  LatLng _markerLocation = const LatLng(-23.52, -51.22);
  String _markerName = "Londrina";
  late GoogleMapController mapController;
  List<List<dynamic>> _data = [];
  late TrackballBehavior _trackballBehavior;
  late TrackballBehavior _trackballBehaviorMedia;
  final TextEditingController _textEditingController = TextEditingController();
  bool isDisconect = false;
  int limitadorDeClicks = 0;
  late Map<String, dynamic> previsao;
  late String? titulo = 'Informe a cidade';
  late String idCidade;
  late List<String> listaCidades = [];
  static late List<int> listaPosicao;
  int pressed = 0;
  int? index;
  int? idx;
  List<String> favoritos = [];
  final List<int> _riscoEstiagem = [];
  final List<double> _mediaEstiagem = [];
  String _cidade = '';
  bool cidadeCondition = false;
  String _mesorregiao = 'Mesorregião';
  bool readyToWrite = false;

  void _setMap(int codEstacao) {
    setState(() {
      _markerLocation = LatLng(CityNames.cityNames[codEstacao]![3], CityNames.cityNames[codEstacao]![4]);
      _markerName = CityNames.cityNames[codEstacao]![0];
    });
  }

  void setSharedPreference() async {
    final SharedPreferences prefs = await _prefs;
    final stationCod = (prefs.getInt('estacaoCod') ?? 2351035);
    final stationNome = (prefs.getString('estacaoNome') ?? 'Londrina');
    _loadCSV().then((value) => _findLocal(stationCod, stationNome));
    _setMap(stationCod);
  }

  @override
  void initState() {
    super.initState();
    initialization();
    setSharedPreference();
    _trackballBehavior = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);

    _trackballBehaviorMedia = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future _loadCSV() async {
    final rawData = await rootBundle.loadString("assets/db/riscoestiagem.csv");
    List<List<dynamic>> listaData = const CsvToListConverter().convert(rawData);
    setState(
      () {
        _data = listaData;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _data.isEmpty && cidadeCondition == false
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: MediaQuery.of(context).orientation.name == 'landscape'
                ? const EdgeInsets.only(left: 40, right: 40, bottom: 8, top: 8)
                : const EdgeInsets.all(8),
            child: Column(
              children: [
                MediaQuery.of(context).orientation.name == 'portrait'
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                onTap: () async {
                                  listaCidades.addAll(ListaCidadesBrasil.listaCidadesBrasil);
                                  setState(
                                    () {
                                      readyToWrite = true;
                                    },
                                  );
                                },
                                onChanged: (text) {
                                  setState(() {
                                    readyToWrite = true;
                                  });
                                  if (_textEditingController.value.composing.isValid == false) {
                                    setState(() {
                                      listaCidades.clear();
                                      listaCidades.addAll(ListaCidadesBrasil.listaCidadesBrasil);
                                      print(_textEditingController.value.composing.isValid);
                                    });
                                  } else {
                                    String cidadeDigitadatoUpperCase =
                                        ListaCidadesBrasilUppercase.formatarNomeUppercase(text);
                                    listaPosicao =
                                        ListaCidadesBrasilUppercase.listarCidadesUpperCase(cidadeDigitadatoUpperCase);

                                    listarCidades(listaPosicao);
                                  }
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                ],
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                enableInteractiveSelection: true,
                                showCursor: true,
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        readyToWrite = false;
                                        listaCidades.clear();
                                        _textEditingController.clear();
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      });
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                  helperText: _textEditingController.value.composing.isValid == false
                                      ? 'Atenção! O nome da cidade deve conter apenas letras.'
                                      : null,
                                  prefixIcon: const Icon(
                                    Icons.search,
                                  ),
                                  prefixIconColor: const Color.fromRGBO(32, 61, 20, 1),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  hintText: 'Ex: Londrina',
                                  filled: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                if (readyToWrite)
                  mostrarListaDigitando()
                else
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Divider(),
                          SfCartesianChart(
                            margin: const EdgeInsets.all(0),
                            trackballBehavior: _trackballBehavior,
                            primaryXAxis: CategoryAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: MediaQuery.of(context).orientation.name == 'portrait' ? 3 : 1,
                              majorGridLines: const MajorGridLines(width: 0),
                              labelRotation: -90,
                              title: AxisTitle(text: 'Decêndios'),
                            ),
                            primaryYAxis: NumericAxis(
                              labelFormat: '{value}%',
                              axisLine: const AxisLine(width: 0),
                              majorTickLines: const MajorTickLines(color: Colors.transparent),
                            ),
                            title: ChartTitle(text: ' Estiagem (%) - $_cidade'),
                            legend: Legend(
                              position: LegendPosition.bottom,
                              isResponsive: true,
                            ),
                            series: <LineSeries<PlotRiscoEstiagem, String>>[
                              LineSeries<PlotRiscoEstiagem, String>(
                                name: 'Estiagem (%)',
                                xAxisName: 'Decêndios',
                                yAxisName: '(%) Estiagem',
                                markerSettings: const MarkerSettings(
                                  height: 5,
                                  width: 5,
                                  isVisible: true,
                                  color: Color.fromRGBO(192, 108, 132, 1),
                                ),
                                dataSource: <PlotRiscoEstiagem>[
                                  PlotRiscoEstiagem('1-10/jan', _riscoEstiagem[0]),
                                  PlotRiscoEstiagem('11-20/jan', _riscoEstiagem[1]),
                                  PlotRiscoEstiagem('21-31/jan', _riscoEstiagem[2]),
                                  PlotRiscoEstiagem('1-10/fev', _riscoEstiagem[3]),
                                  PlotRiscoEstiagem('11-20/fev', _riscoEstiagem[4]),
                                  PlotRiscoEstiagem('21-29fev', _riscoEstiagem[5]),
                                  PlotRiscoEstiagem('1-10/mar', _riscoEstiagem[6]),
                                  PlotRiscoEstiagem('21-31/mar', _riscoEstiagem[7]),
                                  PlotRiscoEstiagem('21-31/mar', _riscoEstiagem[8]),
                                  PlotRiscoEstiagem('1-10/abr', _riscoEstiagem[9]),
                                  PlotRiscoEstiagem('11-20/abr', _riscoEstiagem[10]),
                                  PlotRiscoEstiagem('21-30/abr', _riscoEstiagem[11]),
                                  PlotRiscoEstiagem('1-10/mai', _riscoEstiagem[12]),
                                  PlotRiscoEstiagem('11-20/mai', _riscoEstiagem[13]),
                                  PlotRiscoEstiagem('21-31/mai', _riscoEstiagem[14]),
                                  PlotRiscoEstiagem('1-10/jun', _riscoEstiagem[15]),
                                  PlotRiscoEstiagem('11-20/jun', _riscoEstiagem[16]),
                                  PlotRiscoEstiagem('21-30/jun', _riscoEstiagem[17]),
                                  PlotRiscoEstiagem('1-10/jul', _riscoEstiagem[18]),
                                  PlotRiscoEstiagem('11-20/jul', _riscoEstiagem[19]),
                                  PlotRiscoEstiagem('21-31/jul', _riscoEstiagem[20]),
                                  PlotRiscoEstiagem('1-10/ago', _riscoEstiagem[21]),
                                  PlotRiscoEstiagem('11-20/ago', _riscoEstiagem[22]),
                                  PlotRiscoEstiagem('21-31/ago', _riscoEstiagem[23]),
                                  PlotRiscoEstiagem('1-10/set', _riscoEstiagem[24]),
                                  PlotRiscoEstiagem('11-20/set', _riscoEstiagem[25]),
                                  PlotRiscoEstiagem('21-30/set', _riscoEstiagem[26]),
                                  PlotRiscoEstiagem('1-10/out', _riscoEstiagem[27]),
                                  PlotRiscoEstiagem('11-20/out', _riscoEstiagem[28]),
                                  PlotRiscoEstiagem('21-31/out', _riscoEstiagem[29]),
                                  PlotRiscoEstiagem('1-10/nov', _riscoEstiagem[30]),
                                  PlotRiscoEstiagem('11-20/nov', _riscoEstiagem[31]),
                                  PlotRiscoEstiagem('21-30/nov', _riscoEstiagem[32]),
                                  PlotRiscoEstiagem('1-10/dez', _riscoEstiagem[33]),
                                  PlotRiscoEstiagem('11-20/dez', _riscoEstiagem[34]),
                                  PlotRiscoEstiagem('21-31/dez', _riscoEstiagem[35]),
                                ],
                                xValueMapper: (PlotRiscoEstiagem sales, _) => sales.decendio,
                                yValueMapper: (PlotRiscoEstiagem sales, _) => sales.risco,
                              ),
                            ],
                          ),
                          const Divider(),
                          SfCartesianChart(
                            margin: const EdgeInsets.all(0),
                            onMarkerRender: (MarkerRenderArgs markerargs) {
                              markerargs.color = const Color.fromRGBO(255, 255, 255, 1);
                            },
                            trackballBehavior: _trackballBehaviorMedia,
                            primaryXAxis: CategoryAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              interval: MediaQuery.of(context).orientation.name == 'portrait' ? 3 : 1,
                              majorGridLines: const MajorGridLines(width: 0),
                              labelRotation: -90,
                              title: AxisTitle(text: 'Decêndios'),
                              plotBands: <PlotBand>[
                                PlotBand(
                                  isVisible: true,
                                  start: 16.1,
                                  end: 25.1,
                                  text: 'Inverno',
                                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                  color: const Color.fromRGBO(101, 199, 209, 0.2),
                                  opacity: 0.5,
                                ),
                                PlotBand(
                                  horizontalTextAlignment: TextAnchor.middle,
                                  isVisible: true,
                                  start: -0.5,
                                  end: 7.1,
                                  text: 'Verão',
                                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                  color: const Color.fromRGBO(254, 213, 2, 0.2),
                                  opacity: 0.5,
                                ),
                                PlotBand(
                                  horizontalTextAlignment: TextAnchor.middle,
                                  isVisible: true,
                                  start: 34.1,
                                  end: 36,
                                  text: 'Verão',
                                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                  color: const Color.fromRGBO(254, 213, 2, 0.2),
                                  opacity: 0.5,
                                ),
                                PlotBand(
                                  isVisible: true,
                                  start: 25.1,
                                  end: 34.1,
                                  text: 'Primavera',
                                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                  color: const Color.fromRGBO(140, 198, 62, 0.2),
                                  opacity: 0.5,
                                ),
                                PlotBand(
                                  isVisible: true,
                                  start: 7.1,
                                  end: 16.1,
                                  text: 'Outono',
                                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                  color: const Color.fromRGBO(217, 112, 1, 0.2),
                                  opacity: 0.5,
                                ),
                              ],
                            ),
                            primaryYAxis: NumericAxis(
                              labelFormat: '{value}%',
                              axisLine: const AxisLine(width: 0),
                              majorTickLines: const MajorTickLines(color: Colors.transparent),
                            ),
                            title: ChartTitle(text: 'Média de Estiagem na Região: $_mesorregiao'),
                            legend: Legend(
                              position: LegendPosition.bottom,
                              isResponsive: true,
                            ),
                            series: <LineSeries<PlotMediaMesorregiao, String>>[
                              LineSeries<PlotMediaMesorregiao, String>(
                                color: Colors.deepPurpleAccent,
                                width: 3,
                                name: 'Média Estiagem (%)',
                                xAxisName: 'Decêndios',
                                yAxisName: '(%) Estiagem',
                                markerSettings: const MarkerSettings(
                                  height: 3,
                                  width: 3,
                                  isVisible: true,
                                  borderColor: Color.fromRGBO(192, 108, 132, 1),
                                ),
                                dataSource: <PlotMediaMesorregiao>[
                                  PlotMediaMesorregiao('1-10/jan', _mediaEstiagem[0]),
                                  PlotMediaMesorregiao('11-20/jan', _mediaEstiagem[1]),
                                  PlotMediaMesorregiao('21-31/jan', _mediaEstiagem[2]),
                                  PlotMediaMesorregiao('1-10/fev', _mediaEstiagem[3]),
                                  PlotMediaMesorregiao('11-20/fev', _mediaEstiagem[4]),
                                  PlotMediaMesorregiao('21-29fev', _mediaEstiagem[5]),
                                  PlotMediaMesorregiao('1-10/mar', _mediaEstiagem[6]),
                                  PlotMediaMesorregiao('11-20/mar', _mediaEstiagem[7]),
                                  PlotMediaMesorregiao('21-31/mar', _mediaEstiagem[8]),
                                  PlotMediaMesorregiao('1-10/abr', _mediaEstiagem[9]),
                                  PlotMediaMesorregiao('11-20/abr', _mediaEstiagem[10]),
                                  PlotMediaMesorregiao('21-30/abr', _mediaEstiagem[11]),
                                  PlotMediaMesorregiao('1-10/mai', _mediaEstiagem[12]),
                                  PlotMediaMesorregiao('11-20/mai', _mediaEstiagem[13]),
                                  PlotMediaMesorregiao('21-31/mai', _mediaEstiagem[14]),
                                  PlotMediaMesorregiao('1-10/jun', _mediaEstiagem[15]),
                                  PlotMediaMesorregiao('11-20/jun', _mediaEstiagem[16]),
                                  PlotMediaMesorregiao('21-30/jun', _mediaEstiagem[17]),
                                  PlotMediaMesorregiao('1-10/jul', _mediaEstiagem[18]),
                                  PlotMediaMesorregiao('11-20/jul', _mediaEstiagem[19]),
                                  PlotMediaMesorregiao('21-31/jul', _mediaEstiagem[20]),
                                  PlotMediaMesorregiao('1-10/ago', _mediaEstiagem[21]),
                                  PlotMediaMesorregiao('11-20/ago', _mediaEstiagem[22]),
                                  PlotMediaMesorregiao('21-31/ago', _mediaEstiagem[23]),
                                  PlotMediaMesorregiao('1-10/set', _mediaEstiagem[24]),
                                  PlotMediaMesorregiao('11-20/set', _mediaEstiagem[25]),
                                  PlotMediaMesorregiao('21-30/set', _mediaEstiagem[26]),
                                  PlotMediaMesorregiao('1-10/out', _mediaEstiagem[27]),
                                  PlotMediaMesorregiao('11-20/out', _mediaEstiagem[28]),
                                  PlotMediaMesorregiao('21-31/out', _mediaEstiagem[29]),
                                  PlotMediaMesorregiao('1-10/nov', _mediaEstiagem[30]),
                                  PlotMediaMesorregiao('11-20/nov', _mediaEstiagem[31]),
                                  PlotMediaMesorregiao('21-30/nov', _mediaEstiagem[32]),
                                  PlotMediaMesorregiao('1-10/dez', _mediaEstiagem[33]),
                                  PlotMediaMesorregiao('11-20/dez', _mediaEstiagem[34]),
                                  PlotMediaMesorregiao('21-31/dez', _mediaEstiagem[35]),
                                ],
                                xValueMapper: (PlotMediaMesorregiao sales, _) => sales.decendio,
                                yValueMapper: (PlotMediaMesorregiao sales, _) => sales.risco,
                              ),
                            ],
                          ),
                          const Divider(),
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: SafeArea(
                              child: GoogleMap(
                                zoomGesturesEnabled: true,
                                initialCameraPosition: CameraPosition(
                                  target: _markerLocation,
                                  zoom: 7,
                                ),
                                markers: <Marker>{
                                  Marker(
                                    icon: BitmapDescriptor.defaultMarkerWithHue(100),
                                    markerId: const MarkerId('marker_1'),
                                    position: _markerLocation,
                                    infoWindow: InfoWindow(title: _markerName),
                                  )
                                },
                                mapType: MapType.terrain,
                                onMapCreated: (GoogleMapController controller) {
                                  mapController = controller;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
  }

  Widget mostrarListaDigitando() {
    print('ESTOU DIGITANDO');
    print(listaCidades);
    print(listaCidades.length);
    return Expanded(
      child: ListView.builder(
        itemCount: listaCidades.length,
        itemBuilder: (context, int index) {
          return Card(
            child: ListTile(
              leading: favoritos.contains(listaCidades[index])
                  ? const Icon(
                      Icons.star_purple500_outlined,
                      color: Colors.amber,
                    )
                  : null,
              onTap: () async {
                final SharedPreferences prefs = await _prefs;
                prefs.setInt(
                    'estacaoCod',
                    ListaCidadesBrasil.listaIdCidades[
                        ListaCidadesBrasil.listaCidadesBrasil.indexWhere((element) => element == listaCidades[index])]);
                prefs.setString('estacaoNome', listaCidades[index]);
                _setMap(ListaCidadesBrasil.listaIdCidades[
                    ListaCidadesBrasil.listaCidadesBrasil.indexWhere((element) => element == listaCidades[index])]);
                _loadCSV().whenComplete(() => _findLocal(
                    ListaCidadesBrasil.listaIdCidades[
                        ListaCidadesBrasil.listaCidadesBrasil.indexWhere((element) => element == listaCidades[index])],
                    listaCidades[index]));
              },
              title: Text(
                listaCidades[index],
              ),
            ),
          );
        },
      ),
    );
  }

  listarCidades(List<int> posicaoCidades) {
    setState(
      () {
        listaCidades.clear();
        if (posicaoCidades.isEmpty == true) {
          listaCidades.clear();
        } else {
          for (int i = 0; i < posicaoCidades.length; i++) {
            listaCidades.add(ListaCidadesBrasil.listaCidadesBrasil[posicaoCidades[i]]);
          }
        }
      },
    );
  }

  void _findLocal(int estacao, String cityName) async {
    FocusManager.instance.primaryFocus?.unfocus();
    _mediaEstiagem.clear();
    _riscoEstiagem.clear();
    readyToWrite = false;
    double auxStringToDouble;
    int auxDoubleToInt;
    for (var element in _data) {
      if (element[1] == estacao) {
        auxStringToDouble = double.parse(element[5]);
        auxDoubleToInt = auxStringToDouble.toInt();
        setState(
          () {
            _cidade = cityName;
            _riscoEstiagem.add(auxDoubleToInt);
            _mesorregiao = CityNames.cityNames[estacao]![2];
            cidadeCondition = true;

            ///CONDICIONAL PARA PUXAR O MAPA REGIONAL CORRESPONDENTE À CIDADE.
            CityNames.cityNames[estacao]![2] == 'Centro Ocidental Paranaense'
                ? _mediaEstiagem.addAll(ListaCidadesBrasil.centroOcidentalParanaense)
                : CityNames.cityNames[estacao]![2] == 'Centro Oriental Paranaense'
                    ? _mediaEstiagem.addAll(ListaCidadesBrasil.centroOrientalParanaense)
                    : CityNames.cityNames[estacao]![2] == 'Centro-Sul Paranaense'
                        ? _mediaEstiagem.addAll(ListaCidadesBrasil.centroSulParanaense)
                        : CityNames.cityNames[estacao]![2] == 'Metropolitana de Curitiba'
                            ? _mediaEstiagem.addAll(ListaCidadesBrasil.metropolitanaCuritiba)
                            : CityNames.cityNames[estacao]![2] == 'Noroeste Paranaense'
                                ? _mediaEstiagem.addAll(ListaCidadesBrasil.noroesteParanaense)
                                : CityNames.cityNames[estacao]![2] == 'Norte Central Paranaense'
                                    ? _mediaEstiagem.addAll(ListaCidadesBrasil.norteCentralParanaense)
                                    : CityNames.cityNames[estacao]![2] == 'Norte Pioneiro Paranaense'
                                        ? _mediaEstiagem.addAll(ListaCidadesBrasil.nortePioneiroParanaense)
                                        : CityNames.cityNames[estacao]![2] == 'Oeste Paranaense'
                                            ? _mediaEstiagem.addAll(ListaCidadesBrasil.oesteParanaense)
                                            : CityNames.cityNames[estacao]![2] == 'Sudeste Paranaense'
                                                ? _mediaEstiagem.addAll(ListaCidadesBrasil.sedesteParanaense)
                                                : CityNames.cityNames[estacao]![2] == 'Sudoeste Paranaense'
                                                    ? _mediaEstiagem.addAll(ListaCidadesBrasil.sedoesteParanaense)
                                                    : _mediaEstiagem.clear();
          },
        );
      }
    }
    _textEditingController.clear();
    listaCidades.clear();
  }
}

class PlotRiscoEstiagem {
  PlotRiscoEstiagem(this.decendio, this.risco);
  final String decendio;
  final int risco;
}

class PlotMediaMesorregiao {
  PlotMediaMesorregiao(this.decendio, this.risco);
  final String decendio;
  final double risco;
}
