import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../repository/city_names.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

late GoogleMapController mapController;
const LatLng _center = LatLng(-23.2927, -51.1732);

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _data = [];
  late TrackballBehavior _trackballBehavior;
  late TrackballBehavior _trackballBehaviorMedia;
  @override
  void initState() {

    // Future.delayed(const Duration(seconds: 2)).then((value) => _findLocal(2351035, 'Londrina-PR'));
    _findLocal(2351035, 'Londrina-PR');
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  Future<List<List>> _loadCSV() async {
    final rawData = await rootBundle.loadString("assets/db/riscoestiagem.csv");
    List<List<dynamic>> listaData = const CsvToListConverter().convert(rawData);
    return listaData;
    // setState(
    //   () {
    //     _data = listaData;
    //   },
    // );
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Risco Estiagem Paraná"),
        centerTitle: true,
        actions: [
          Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset(
                'assets/assets_drawer/Logo_IDR.png',
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              title: const Text('Introdução'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Metodologia'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Média Regional de Estiagem'),
              onTap: () {},
            ),
            const Divider(),

            ListTile(
              title: const Text('Sobre'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Equipe Técnica'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Ajuda'),
              onTap: () {},
            ),
            // ListTile(
            //   title: const Text('Mesorregião'),
            //   onTap: () {
            //     Get.to(const Mesorregiao());
            //   },
            // ),
          ],
        ),
      ),
      body: _data.isEmpty && cidadeCondition == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onTap: () {
                              listaCidades.addAll(ListaCidadesBrasil.listaCidadesBrasil);
                              setState(
                                () {
                                  readyToWrite = true;
                                },
                              );
                            },
                            onChanged: (text) {
                              String cidadeDigitadatoUpperCase =
                                  ListaCidadesBrasilUppercase.formatarNomeUppercase(text);
                              listaPosicao =
                                  ListaCidadesBrasilUppercase.listarCidadesUpperCase(cidadeDigitadatoUpperCase);

                              listarCidades(listaPosicao);
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            autocorrect: true,
                            enableInteractiveSelection: true,
                            showCursor: true,
                            controller: _textEditingController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                              ),
                              prefixIconColor: Color.fromRGBO(32, 61, 20, 1),
                              border: OutlineInputBorder(
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
                  ),
                  if (readyToWrite)
                    mostrarListaDigitando()
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SfCartesianChart(
                              trackballBehavior: _trackballBehavior,
                              primaryXAxis: CategoryAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                interval: 3,
                                majorGridLines: const MajorGridLines(width: 0),
                                maximumLabels: 36,
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
                                    PlotRiscoEstiagem('jan-1', _riscoEstiagem[0]),
                                    PlotRiscoEstiagem('jan-2', _riscoEstiagem[1]),
                                    PlotRiscoEstiagem('jan-3', _riscoEstiagem[2]),
                                    PlotRiscoEstiagem('fev-1', _riscoEstiagem[3]),
                                    PlotRiscoEstiagem('fev-2', _riscoEstiagem[4]),
                                    PlotRiscoEstiagem('fev-3', _riscoEstiagem[5]),
                                    PlotRiscoEstiagem('mar-1', _riscoEstiagem[6]),
                                    PlotRiscoEstiagem('mar-2', _riscoEstiagem[7]),
                                    PlotRiscoEstiagem('mar-3', _riscoEstiagem[8]),
                                    PlotRiscoEstiagem('abr-1', _riscoEstiagem[9]),
                                    PlotRiscoEstiagem('abr-2', _riscoEstiagem[10]),
                                    PlotRiscoEstiagem('abr-3', _riscoEstiagem[11]),
                                    PlotRiscoEstiagem('mai-1', _riscoEstiagem[12]),
                                    PlotRiscoEstiagem('mai-2', _riscoEstiagem[13]),
                                    PlotRiscoEstiagem('mai-3', _riscoEstiagem[14]),
                                    PlotRiscoEstiagem('jun-1', _riscoEstiagem[15]),
                                    PlotRiscoEstiagem('jun-2', _riscoEstiagem[16]),
                                    PlotRiscoEstiagem('jun-3', _riscoEstiagem[17]),
                                    PlotRiscoEstiagem('jul-1', _riscoEstiagem[18]),
                                    PlotRiscoEstiagem('jul-2', _riscoEstiagem[19]),
                                    PlotRiscoEstiagem('jul-3', _riscoEstiagem[20]),
                                    PlotRiscoEstiagem('ago-1', _riscoEstiagem[21]),
                                    PlotRiscoEstiagem('ago-2', _riscoEstiagem[22]),
                                    PlotRiscoEstiagem('ago-3', _riscoEstiagem[23]),
                                    PlotRiscoEstiagem('set-1', _riscoEstiagem[24]),
                                    PlotRiscoEstiagem('set-2', _riscoEstiagem[25]),
                                    PlotRiscoEstiagem('set-3', _riscoEstiagem[26]),
                                    PlotRiscoEstiagem('out-1', _riscoEstiagem[27]),
                                    PlotRiscoEstiagem('out-2', _riscoEstiagem[28]),
                                    PlotRiscoEstiagem('out-3', _riscoEstiagem[29]),
                                    PlotRiscoEstiagem('nov-1', _riscoEstiagem[30]),
                                    PlotRiscoEstiagem('nov-2', _riscoEstiagem[31]),
                                    PlotRiscoEstiagem('nov-3', _riscoEstiagem[32]),
                                    PlotRiscoEstiagem('dez-1', _riscoEstiagem[33]),
                                    PlotRiscoEstiagem('dez-2', _riscoEstiagem[34]),
                                    PlotRiscoEstiagem('dez-3', _riscoEstiagem[35]),
                                  ],
                                  xValueMapper: (PlotRiscoEstiagem sales, _) => sales.decendio,
                                  yValueMapper: (PlotRiscoEstiagem sales, _) => sales.risco,
                                ),
                              ],
                            ),
                            SfCartesianChart(
                              onMarkerRender: (MarkerRenderArgs markerargs) {
                                markerargs.color = const Color.fromRGBO(255, 255, 255, 1);
                              },
                              trackballBehavior: _trackballBehaviorMedia,
                              primaryXAxis: CategoryAxis(
                                edgeLabelPlacement: EdgeLabelPlacement.shift,
                                interval: 3,
                                majorGridLines: const MajorGridLines(width: 0),
                                maximumLabels: 36,
                                labelRotation: -90,
                                title: AxisTitle(text: 'Decêndios'),
                                plotBands: <PlotBand>[
                                  PlotBand(
                                      isVisible: true,
                                      start: 16.1,
                                      end: 25.1,
                                      text: 'Inverno',
                                      textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                      color: const Color.fromRGBO(101, 199, 209, 1)),
                                  PlotBand(
                                      horizontalTextAlignment: TextAnchor.middle,
                                      isVisible: true,
                                      start: -0.5,
                                      end: 7.1,
                                      text: 'Verão',
                                      textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                      color: const Color.fromRGBO(254, 213, 2, 1)),
                                  PlotBand(
                                      horizontalTextAlignment: TextAnchor.middle,
                                      isVisible: true,
                                      start: 34.1,
                                      end: 36,
                                      text: 'Verão',
                                      textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                      color: const Color.fromRGBO(254, 213, 2, 1)),
                                  PlotBand(
                                      isVisible: true,
                                      start: 25.1,
                                      end: 34.1,
                                      text: 'Primavera',
                                      textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                      color: const Color.fromRGBO(140, 198, 62, 1)),
                                  PlotBand(
                                      isVisible: true,
                                      start: 7.1,
                                      end: 16.1,
                                      text: 'Outono',
                                      textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                                      color: const Color.fromRGBO(217, 112, 1, 1)),
                                ],
                              ),
                              primaryYAxis: NumericAxis(
                                labelFormat: '{value}%',
                                axisLine: const AxisLine(width: 0),
                                majorTickLines: const MajorTickLines(color: Colors.transparent),
                              ),
                              title: ChartTitle(text: 'Média de Estiagem (%) - Região: $_mesorregiao'),
                              legend: Legend(
                                position: LegendPosition.bottom,
                                isResponsive: true,
                              ),
                              series: <LineSeries<PlotMediaMesorregiao, String>>[
                                LineSeries<PlotMediaMesorregiao, String>(
                                  color: Colors.white,
                                  name: 'Média Estiagem (%)',
                                  xAxisName: 'Decêndios',
                                  yAxisName: '(%) Estiagem',
                                  markerSettings: const MarkerSettings(
                                    height: 3,
                                    width: 3,
                                    isVisible: true,
                                    color: Color.fromRGBO(192, 108, 132, 1),
                                  ),
                                  dataSource: <PlotMediaMesorregiao>[
                                    PlotMediaMesorregiao('jan-1', _mediaEstiagem[0]),
                                    PlotMediaMesorregiao('jan-2', _mediaEstiagem[1]),
                                    PlotMediaMesorregiao('jan-3', _mediaEstiagem[2]),
                                    PlotMediaMesorregiao('fev-1', _mediaEstiagem[3]),
                                    PlotMediaMesorregiao('fev-2', _mediaEstiagem[4]),
                                    PlotMediaMesorregiao('fev-3', _mediaEstiagem[5]),
                                    PlotMediaMesorregiao('mar-1', _mediaEstiagem[6]),
                                    PlotMediaMesorregiao('mar-2', _mediaEstiagem[7]),
                                    PlotMediaMesorregiao('mar-3', _mediaEstiagem[8]),
                                    PlotMediaMesorregiao('abr-1', _mediaEstiagem[9]),
                                    PlotMediaMesorregiao('abr-2', _mediaEstiagem[10]),
                                    PlotMediaMesorregiao('abr-3', _mediaEstiagem[11]),
                                    PlotMediaMesorregiao('mai-1', _mediaEstiagem[12]),
                                    PlotMediaMesorregiao('mai-2', _mediaEstiagem[13]),
                                    PlotMediaMesorregiao('mai-3', _mediaEstiagem[14]),
                                    PlotMediaMesorregiao('jun-1', _mediaEstiagem[15]),
                                    PlotMediaMesorregiao('jun-2', _mediaEstiagem[16]),
                                    PlotMediaMesorregiao('jun-3', _mediaEstiagem[17]),
                                    PlotMediaMesorregiao('jul-1', _mediaEstiagem[18]),
                                    PlotMediaMesorregiao('jul-2', _mediaEstiagem[19]),
                                    PlotMediaMesorregiao('jul-3', _mediaEstiagem[20]),
                                    PlotMediaMesorregiao('ago-1', _mediaEstiagem[21]),
                                    PlotMediaMesorregiao('ago-2', _mediaEstiagem[22]),
                                    PlotMediaMesorregiao('ago-3', _mediaEstiagem[23]),
                                    PlotMediaMesorregiao('set-1', _mediaEstiagem[24]),
                                    PlotMediaMesorregiao('set-2', _mediaEstiagem[25]),
                                    PlotMediaMesorregiao('set-3', _mediaEstiagem[26]),
                                    PlotMediaMesorregiao('out-1', _mediaEstiagem[27]),
                                    PlotMediaMesorregiao('out-2', _mediaEstiagem[28]),
                                    PlotMediaMesorregiao('out-3', _mediaEstiagem[29]),
                                    PlotMediaMesorregiao('nov-1', _mediaEstiagem[30]),
                                    PlotMediaMesorregiao('nov-2', _mediaEstiagem[31]),
                                    PlotMediaMesorregiao('nov-3', _mediaEstiagem[32]),
                                    PlotMediaMesorregiao('dez-1', _mediaEstiagem[33]),
                                    PlotMediaMesorregiao('dez-2', _mediaEstiagem[34]),
                                    PlotMediaMesorregiao('dez-3', _mediaEstiagem[35]),
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
                              height: 250,
                              child: const GoogleMap(
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(target: _center, zoom: 5.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
    );
  }

  Widget mostrarListaDigitando() {
    return Expanded(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
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
                onTap: () {
                  setState(
                    () {

                      FocusManager.instance.primaryFocus?.unfocus();
                      _mediaEstiagem.clear();
                      _riscoEstiagem.clear();
                      readyToWrite = false;
                    },
                  );
                  _findLocal(
                      ListaCidadesBrasil.listaIdCidades[ListaCidadesBrasil.listaCidadesBrasil
                          .indexWhere((element) => element == listaCidades[index])],
                      listaCidades[index]);
                },
                title: Text(
                  listaCidades[index],
                ),
              ),
            );
          },
        ),
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
   _data = await _loadCSV().whenComplete(() => null);
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
