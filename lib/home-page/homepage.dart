import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
    super.initState();
    initialization();
    _loadCSV().then((value) => _findLocal(2351035, 'Londrina'));
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
    List<List<dynamic>> listaData = const CsvToListConverter(eol: "\n").convert(rawData);
    setState(
      () {
        _data = listaData;
      },
    );
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
        backgroundColor: Colors.green,
        elevation: 0,
        toolbarHeight: 48,
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
              title: const Text('Apresentação'),
              onTap: () {
                Navigator.of(context).pushNamed('/introducao');
              },
            ),
            ListTile(
              title: const Text('Metodologia'),
              onTap: () {
                Navigator.of(context).pushNamed('/metodologia');
              },
            ),
            ListTile(
              title: const Text('Média Regional de Estiagem'),
              onTap: () {
                Navigator.of(context).pushNamed('/media_regional');
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sobre'),
              onTap: () {
                Navigator.of(context).pushNamed('/sobre');
              },
            ),
            ListTile(
              title: const Text('Equipe Técnica'),
              onTap: () {
                Navigator.of(context).pushNamed('/equipe_tecnica');
              },
            ),
            // const Divider(),
            // ListTile(
            //   title: const Text('Ajuda'),
            //   onTap: () {
            //     Navigator.pushNamed(context,'/ajuda');
            //     //Get.toNamed('/ajuda');
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
                  MediaQuery.of(context).orientation.name == 'portrait'
                      ? Row(
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
                        )
                      : const SizedBox.shrink(),
                  if (readyToWrite)
                    mostrarListaDigitando()
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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
                onTap: () async {
                  _loadCSV().whenComplete(() => _findLocal(
                      ListaCidadesBrasil.listaIdCidades[ListaCidadesBrasil.listaCidadesBrasil
                          .indexWhere((element) => element == listaCidades[index])],
                      listaCidades[index]));
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
