import 'package:csv/csv.dart';
import 'package:estiagem/views/chose_by_mesosphere.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  @override
  void initState() {
    _loadCSV();
    super.initState();
  }

  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/db/riscoestiagem.csv");
    List<List<dynamic>> _listaData = const CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listaData;
    });
  }

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _textEditingController = TextEditingController();
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDisconect = false;
  int limitadorDeClicks = 0;
  late Map<String, dynamic> previsao;
  late String? titulo = 'Informe a cidade';
  late String idCidade;
  late List<String> listaCidades = [];
  //static late List<int> listaPosicao;
  int pressed = 0;
  int? index;
  int? idx;
  // bool _isLoading = false;
  List<String> favoritos = [];

  // _lerListaFavoritos() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     favoritos = prefs.getStringList('favoritos') ?? [];
  //     favoritos.sort();
  //   });
  // }

  // _removerFavorito(String cidadeRemovida) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     favoritos.removeWhere((element) => element == cidadeRemovida);
  //     prefs.remove('favoritos');
  //     prefs.setStringList('favoritos', favoritos);
  //     favoritos = prefs.getStringList('favoritos') ?? [];
  //   });
  // }

  // @override
  // void setState(fn) {
  //   if (mounted) {
  //     super.setState(fn);
  //   }
  // }

  // @override
  // void initState() {
  //   initConnectivity();
  //   _connectivitySubscription =
  //       _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  //   _lerListaFavoritos();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _connectivitySubscription.cancel();
  //   _textEditingController.dispose();
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print('Couldn\'t check connectivity status $e');
  //     return;
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //
  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   if (result == ConnectivityResult.none && !isDisconect) {
  //     setState(() {
  //       isDisconect = true;
  //     });
  //   }
  //
  //   if (result == ConnectivityResult.wifi && isDisconect) {
  //     setState(() {
  //       isDisconect = false;
  //     });
  //   }
  //
  //   if (result == ConnectivityResult.mobile && isDisconect) {
  //     setState(() {
  //       isDisconect = false;
  //     });
  //   }
  // }

  // void _openEndDrawer() {
  //   _scaffoldKey.currentState!.openEndDrawer();
  // }
  final List<int>? _riscoEstiagem = [];
  String _cidade = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Risco Estiagem Paraná"), centerTitle: true, actions: [
        IconButton(
          onPressed: () {
            _loadCSV();
          },
          icon: Image.asset('assets/assets_appBar/icon_idr_colored.png'),
        ),
      ]),
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
              title: const Text('Mesorregião'),
              onTap: () {
                Get.to(const Mesorregiao());
              },
            )
          ],
        ),
      ),
      body: _data.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :

          // ListView.builder(
          //   itemCount: _data.length,
          //   itemBuilder: (_, index) {
          //     return Card(
          //       margin: const EdgeInsets.all(3),
          //       color: index == 0 ? Colors.amber : Colors.white,
          //       child: ListTile(
          //         leading: Text(_data[index][1].toString()),
          //         title: Text(_data[index][2].toString()),
          //         trailing: Text(_data[index][5].toString()),
          //       ),
          //     );
          //   },
          // ),

          ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15))),
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: const GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(target: _center, zoom: 5.5),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(

                                  onSubmitted: (text) {
                                    int cidade = int.parse(text);
                                    double auxStringToDouble;
                                    int auxDoubleToInt;
                                    for (var element in _data) {
                                      if (element[1] == cidade) {
                                        auxStringToDouble = double.parse(element[5]);
                                        assert(auxStringToDouble is double);
                                        auxDoubleToInt = auxStringToDouble.toInt();
                                        setState(
                                          () {
                                            _riscoEstiagem?.add(auxDoubleToInt);
                                            _cidade = element[2];
                                          },
                                        );

                                      }
                                    }
                                    _textEditingController.clear();
                                  },
                                  onChanged: (text) {
                                    print(_textEditingController);
                                    // String cidadeDigitadatoUpperCase =
                                    // ListaCidadesBrasilUppercase
                                    //  .formatarNomeUppercase(text);
                                    // listaPosicao = ListaCidadesBrasilUppercase
                                    //   .listarCidadesUpperCase(
                                    //   cidadeDigitadatoUpperCase);
                                    //print(listaPosicao);
                                    // for (int i = 0; i < listaPosicao.length; i++) {
                                    // print(ListaCidadesParana.listaCidadesParana
                                    //     .elementAt(listaPosicao[i]));
                                    // }

                                    // listarCidades(listaPosicao);
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
                        //   _textEditingController.text == ''
                        // ? mostrarFavoritos()
                        // : mostrarListaDigitando()
                      ],
                    ),
                        SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                                interval: 3,
                                minorTicksPerInterval: 2,
                                maximumLabels: 36,
                                labelRotation: -90,
                                title: AxisTitle(text: 'Decêndios')),
                            title: ChartTitle(text: _cidade),
                            legend: Legend(
                              position: LegendPosition.bottom,
                              isResponsive: true,
                            ),
                            series: <LineSeries<PlotRiscoEstiagem, String>>[
                              LineSeries<PlotRiscoEstiagem, String>(
                                  enableTooltip: true,
                                  xAxisName: 'Decêndios',
                                  yAxisName: '(%) Risco de Estiagem',
                                  dataSource: <PlotRiscoEstiagem>[
                                    PlotRiscoEstiagem('jan-1', 3),
                                    PlotRiscoEstiagem('jan-2', 4),
                                    PlotRiscoEstiagem('jan-1', _riscoEstiagem![0]),
                                    PlotRiscoEstiagem('jan-2', _riscoEstiagem![1]),
                                    PlotRiscoEstiagem('jan-3', _riscoEstiagem![2]),
                                    PlotRiscoEstiagem('fev-1', _riscoEstiagem![3]),
                                    PlotRiscoEstiagem('fev-2', _riscoEstiagem![4]),
                                    PlotRiscoEstiagem('fev-3', _riscoEstiagem![5]),
                                    PlotRiscoEstiagem('mar-1', _riscoEstiagem![6]),
                                    PlotRiscoEstiagem('mar-2', _riscoEstiagem![7]),
                                    PlotRiscoEstiagem('mar-3', _riscoEstiagem![8]),
                                    PlotRiscoEstiagem('abr-1', _riscoEstiagem![9]),
                                    PlotRiscoEstiagem('abr-2', _riscoEstiagem![10]),
                                    PlotRiscoEstiagem('abr-3', _riscoEstiagem![11]),
                                    PlotRiscoEstiagem('mai-1', _riscoEstiagem![12]),
                                    PlotRiscoEstiagem('mai-2', _riscoEstiagem![13]),
                                    PlotRiscoEstiagem('mai-3', _riscoEstiagem![14]),
                                    PlotRiscoEstiagem('jun-1', _riscoEstiagem![15]),
                                    PlotRiscoEstiagem('jun-2', _riscoEstiagem![16]),
                                    PlotRiscoEstiagem('jun-3', _riscoEstiagem![17]),
                                    PlotRiscoEstiagem('jul-1', _riscoEstiagem![18]),
                                    PlotRiscoEstiagem('jul-2', _riscoEstiagem![19]),
                                    PlotRiscoEstiagem('jul-3', _riscoEstiagem![20]),
                                    PlotRiscoEstiagem('ago-1', _riscoEstiagem![21]),
                                    PlotRiscoEstiagem('ago-2', _riscoEstiagem![22]),
                                    PlotRiscoEstiagem('ago-3', _riscoEstiagem![23]),
                                    PlotRiscoEstiagem('set-1', _riscoEstiagem![24]),
                                    PlotRiscoEstiagem('set-2', _riscoEstiagem![25]),
                                    PlotRiscoEstiagem('set-3', _riscoEstiagem![26]),
                                    PlotRiscoEstiagem('out-1', _riscoEstiagem![27]),
                                    PlotRiscoEstiagem('out-2', _riscoEstiagem![28]),
                                    PlotRiscoEstiagem('out-3', _riscoEstiagem![29]),
                                    PlotRiscoEstiagem('nov-1', _riscoEstiagem![30]),
                                    PlotRiscoEstiagem('nov-2', _riscoEstiagem![31]),
                                    PlotRiscoEstiagem('nov-3', _riscoEstiagem![32]),
                                    PlotRiscoEstiagem('dez-1', _riscoEstiagem![33]),
                                    PlotRiscoEstiagem('dez-2', _riscoEstiagem![34]),
                                    PlotRiscoEstiagem('dez-2', _riscoEstiagem![35]),
                                  ],
                                  xValueMapper: (PlotRiscoEstiagem sales, _) => sales.decendio,
                                  yValueMapper: (PlotRiscoEstiagem sales, _) => sales.risco as int,
                                  dataLabelSettings: const DataLabelSettings(isVisible: true))
                            ],
                          )

                  ],
                ),
              ),
            ]),
    );
  }
}

class PlotRiscoEstiagem {
  PlotRiscoEstiagem(this.decendio, this.risco);
  final String decendio;
  final int risco;
}
// class Previsao extends StatefulWidget {
//   const Previsao({Key? key}) : super(key: key);
//
//   @override
//   State<Previsao> createState() => _PrevisaoState();
// }
//
// class _PrevisaoState extends State<Previsao> {
//
//   @override
//   Widget build(BuildContext context) {
//     _lerListaFavoritos();
//     return Scaffold(
//       floatingActionButton: FloatingActionButton.small(
//         backgroundColor: Theme.of(context).primaryColorLight,
//         onPressed: () {
//           _openEndDrawer();
//           _lerListaFavoritos();
//         },
//         child: favoritos.isNotEmpty
//             ? const Icon(
//           Icons.star,
//           color: Colors.amberAccent,
//         )
//             : const Icon(Icons.star_border_outlined),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
//       key: _scaffoldKey,
//       endDrawer: _isLoading
//           ? Center(
//         child: progressIndicator(),
//       )
//           : Drawer(
//         child: favoritos.isNotEmpty
//             ? Column(
//           children: [
//             const Text(
//               'Lista de Favoritos',
//               style: TextStyle(
//                 fontSize: 20,
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: favoritos.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text(favoritos[index],
//                           style: const TextStyle(fontSize: 16)),
//                       leading: IconButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (_) => AlertDialog(
//                               actionsAlignment:
//                               MainAxisAlignment.spaceEvenly,
//                               title:
//                               const Text('Lista de Favoritos'),
//                               content: Text(
//                                   'Deseja remover ${favoritos[index]} da lista de favoritos?'),
//                               actions: [
//                                 ElevatedButton(
//                                     onPressed: () {
//                                       _removerFavorito(
//                                           favoritos[index]);
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('Sim')),
//                                 ElevatedButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('Não'))
//                               ],
//                             ),
//                           );
//
//                           //
//                         },
//                         icon: const Icon(
//                           Icons.highlight_remove_outlined,
//                           color: Colors.red,
//                         ),
//                       ),
//                       onTap: () {
//                         isDisconect
//                             ? ScaffoldMessenger.of(context)
//                             .showSnackBar(const SnackBar(
//                             backgroundColor: Colors.red,
//                             content: Text(
//                               "Sem internet",
//                               style: TextStyle(
//                                   color: Colors.white),
//                             )))
//                             : _getDados(
//                             ListaCidadesBrasil
//                                 .listaCidadesBrasil
//                                 .indexWhere((element) =>
//                             element ==
//                                 favoritos[index]),
//                             favoritos[index]);
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         )
//             : const Center(
//           child: Text(
//             'Não há favoritos',
//             style: TextStyle(fontSize: 20),
//           ),
//         ),
//       ),
//       body: _isLoading
//           ? Center(
//         child: progressIndicator(),
//       )
//           : Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     onChanged: (text) {
//                       String cidadeDigitadatoUpperCase =
//                       ListaCidadesBrasilUppercase
//                           .formatarNomeUppercase(text);
//                       listaPosicao = ListaCidadesBrasilUppercase
//                           .listarCidadesUpperCase(
//                           cidadeDigitadatoUpperCase);
//                       //print(listaPosicao);
//                       for (int i = 0; i < listaPosicao.length; i++) {
//                         // print(ListaCidadesParana.listaCidadesParana
//                         //     .elementAt(listaPosicao[i]));
//                       }
//
//                       listarCidades(listaPosicao);
//                     },
//                     keyboardType: TextInputType.text,
//                     textCapitalization: TextCapitalization.words,
//                     autocorrect: true,
//                     enableInteractiveSelection: true,
//                     showCursor: true,
//                     controller: _textEditingController,
//                     decoration: const InputDecoration(
//                       prefixIcon: Icon(
//                         Icons.search,
//                       ),
//                       prefixIconColor: Color.fromRGBO(32, 61, 20, 1),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                       ),
//                       hintText: 'Ex: Londrina',
//                       filled: true,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           _textEditingController.text == ''
//               ? mostrarFavoritos()
//               : mostrarListaDigitando()
//         ],
//       ),
//     );
//   }

//   Widget mostrarFavoritos() {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: favoritos.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               leading: const Icon(
//                 Icons.star_purple500_outlined,
//                 color: Colors.amber,
//               ),
//               onTap: () {
//                 isDisconect
//                     ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                     backgroundColor: Colors.red,
//                     content: Text(
//                       "Sem internet",
//                       style: TextStyle(color: Colors.white),
//                     )))
//                     : _getDados(
//                     ListaCidadesBrasil.listaCidadesBrasil.indexWhere(
//                             (element) => element == favoritos[index]),
//                     favoritos[index]);
//               },
//               title: Text(favoritos[index]),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget mostrarListaDigitando() {
//     return Expanded(
//       child: Container(
//         constraints: const BoxConstraints(maxWidth: 500),
//         child: ListView.builder(
//           itemCount: listaCidades.length,
//           itemBuilder: (context, int index) {
//             return Card(
//               child: ListTile(
//                 leading: favoritos.contains(listaCidades[index])
//                     ? const Icon(
//                   Icons.star_purple500_outlined,
//                   color: Colors.amber,
//                 )
//                     : null,
//                 onTap: () {
//                   isDisconect
//                       ? ScaffoldMessenger.of(context)
//                       .showSnackBar(const SnackBar(
//                       backgroundColor: Colors.red,
//                       content: Text(
//                         "Sem internet",
//                         style: TextStyle(color: Colors.white),
//                       )))
//                       : _getDados(
//                       ListaCidadesBrasil.listaCidadesBrasil.indexWhere(
//                               (element) => element == listaCidades[index]),
//                       listaCidades[index]);
//                 },
//                 title: Text(listaCidades[index]),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   listarCidades(List<int> posicaoCidades) {
//     setState(
//           () {
//         listaCidades.clear();
//         if (posicaoCidades.isEmpty == true) {
//           listaCidades.clear();
//         } else {
//           for (int i = 0; i < posicaoCidades.length; i++) {
//             listaCidades
//                 .add(ListaCidadesBrasil.listaCidadesBrasil[posicaoCidades[i]]);
//           }
//         }
//       },
//     );
//   }
//
//   Future<Map<String, dynamic>?> _getDados(
//       int cityPosition, String cidade) async {
//     HttpOverrides.global = MyHttpOverrides();
//     setState(() {
//       _isLoading = true;
//     });
//     String geocode =
//     ListaCidadesBrasil.listaIdCidades.elementAt(cityPosition).toString();
//     await http
//         .get(Uri.parse('https://apiprevmet3.inmet.gov.br/previsao/$geocode'))
//         .then(
//           (value) => setState(
//             () {
//           if (value.statusCode == 200) {
//             previsao = json.decode(value.body);
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (BuildContext context) =>
//                     TelaPrevisao(previsao: previsao, titulo: cidade),
//               ),
//             );
//             FocusScope.of(context).requestFocus(FocusNode());
//             _textEditingController.clear();
//           } else {
//             showDialog(
//               context: context,
//               builder: (_) => AlertDialog(
//                 actionsAlignment: MainAxisAlignment.spaceEvenly,
//                 title: const Text('Oops! Ocorreu um erro...'),
//                 content: Text(
//                     'Erro: ${value.statusCode}\nPor favor, tente novamente mais tarde...'),
//                 actions: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.of(context)
//                           .popUntil(ModalRoute.withName('/'));
//                     },
//                     child: const Text('Ok'),
//                   ),
//                 ],
//               ),
//             );
//             //     print('Request failed with status: ${value.statusCode}.');
//           }
//           _isLoading = false;
//         },
//       ),
//     );
//     return null;
//   }
// }
