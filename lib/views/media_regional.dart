import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../repository/chart.dart';
import '../repository/city_names.dart';

class MediaRegional extends StatefulWidget {
  const MediaRegional({Key? key}) : super(key: key);

  @override
  State<MediaRegional> createState() => _MediaRegionalState();
}

class _MediaRegionalState extends State<MediaRegional> {
  late TrackballBehavior _trackballBehavior1;
  late TrackballBehavior _trackballBehavior2;
  late TrackballBehavior _trackballBehavior3;
  late TrackballBehavior _trackballBehavior4;
  late TrackballBehavior _trackballBehavior5;
  late TrackballBehavior _trackballBehavior6;
  late TrackballBehavior _trackballBehavior7;
  late TrackballBehavior _trackballBehavior8;
  late TrackballBehavior _trackballBehavior9;
  late TrackballBehavior _trackballBehavior10;
  @override
  void initState() {
    _trackballBehavior1 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior2 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior3 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior4 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior5 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior6 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior7 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior8 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior9 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    _trackballBehavior10 = TrackballBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        markerSettings:
            const TrackballMarkerSettings(markerVisibility: TrackballVisibilityMode.visible, borderColor: Colors.black),
        tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return buildPlots('Centro Ocidental Paranaense', ListaCidadesBrasil.centroOcidentalParanaense, index);
          case 1:
            return buildPlots('Centro Oriental Paranaense', ListaCidadesBrasil.centroOrientalParanaense, index);
          case 2:
            return buildPlots('Centro Sul Paranaense', ListaCidadesBrasil.centroSulParanaense, index);
          case 3:
            return buildPlots('Metropolitana de Curitiba', ListaCidadesBrasil.metropolitanaCuritiba, index);
          case 4:
            return buildPlots('Noroeste Paranaense', ListaCidadesBrasil.noroesteParanaense, index);
          case 5:
            return buildPlots('Norte Central Paranaense', ListaCidadesBrasil.norteCentralParanaense, index);
          case 6:
            return buildPlots('Norte Pioneiro Paranaense', ListaCidadesBrasil.nortePioneiroParanaense, index);
          case 7:
            return buildPlots('Oeste Paranaense', ListaCidadesBrasil.oesteParanaense, index);
          case 8:
            return buildPlots('Sudeste Paranaense', ListaCidadesBrasil.sudesteParanaense, index);
          case 9:
            return buildPlots('Sudoeste Paranaense', ListaCidadesBrasil.sudoesteParanaense, index);
        }
        return const SizedBox.square(
          dimension: 2,
        );
      },
    );
  }

  Padding buildPlots(String regiao, List<double> list, int idx) {
    return Padding(
      padding: MediaQuery.of(context).orientation.name == 'landscape'
          ? const EdgeInsets.only(left: 40, right: 40, bottom: 8, top: 8)
          : const EdgeInsets.all(8),
      child: Column(
        children: [
          SfCartesianChart(

            margin: const EdgeInsets.all(0),
            onMarkerRender: (MarkerRenderArgs markerargs) {
              markerargs.color = const Color.fromRGBO(255, 255, 255, 1);
            },
            trackballBehavior: idx == 0
                ? _trackballBehavior1
                : idx == 1
                    ? _trackballBehavior2
                    : idx == 2
                        ? _trackballBehavior3
                        : idx ==3
                            ? _trackballBehavior4
                            : idx == 4
                                ? _trackballBehavior5
                                : idx == 5
                                    ? _trackballBehavior6
                                    : idx == 6
                                        ? _trackballBehavior7
                                        : idx == 7
                                            ? _trackballBehavior8
                                            : idx == 8
                                                ? _trackballBehavior9
                                                : idx == 9 ? _trackballBehavior10:null,
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
                  opacity: 0.2,
                ),
                PlotBand(
                  horizontalTextAlignment: TextAnchor.middle,
                  isVisible: true,
                  start: -0.5,
                  end: 7.1,
                  text: 'Verão',
                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                  color: const Color.fromRGBO(254, 213, 2, 0.2),
                  opacity: 0.2,
                ),
                PlotBand(
                  horizontalTextAlignment: TextAnchor.middle,
                  isVisible: true,
                  start: 34.1,
                  end: 36,
                  text: 'Verão',
                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                  color: const Color.fromRGBO(254, 213, 2, 0.2),
                  opacity: 0.2,
                ),
                PlotBand(
                  isVisible: true,
                  start: 25.1,
                  end: 34.1,
                  text: 'Primavera',
                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                  color: const Color.fromRGBO(140, 198, 62, 0.2),
                  opacity: 0.2,
                ),
                PlotBand(
                  isVisible: true,
                  start: 7.1,
                  end: 16.1,
                  text: 'Outono',
                  textStyle: const TextStyle(color: Colors.black, fontSize: 13),
                  color: const Color.fromRGBO(217, 112, 1, 0.2),
                  opacity: 0.2,
                ),
              ],
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 70,
              labelFormat: '{value}%',
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(color: Colors.transparent),
            ),
            title: ChartTitle(text: 'Média de Estiagem na Região: $regiao'),
            legend: Legend(
              position: LegendPosition.bottom,
              isResponsive: true,
            ),
            series: [
              PlotMinAndMax.minLine,
              PlotMinAndMax.maxLine,
              LineSeries<PlotMedia, String>(

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
                dataSource: <PlotMedia>[
                  PlotMedia('1-10/jan', list[0]),
                  PlotMedia('11-20/jan', list[1]),
                  PlotMedia('21-31/jan', list[2]),
                  PlotMedia('1-10/fev', list[3]),
                  PlotMedia('11-20/fev', list[4]),
                  PlotMedia('21-29fev', list[5]),
                  PlotMedia('1-10/mar', list[6]),
                  PlotMedia('11-20/mar', list[7]),
                  PlotMedia('21-31/mar', list[8]),
                  PlotMedia('1-10/abr', list[9]),
                  PlotMedia('11-20/abr', list[10]),
                  PlotMedia('21-30/abr', list[11]),
                  PlotMedia('1-10/mai', list[12]),
                  PlotMedia('11-20/mai', list[13]),
                  PlotMedia('21-31/mai', list[14]),
                  PlotMedia('1-10/jun', list[15]),
                  PlotMedia('11-20/jun', list[16]),
                  PlotMedia('21-30/jun', list[17]),
                  PlotMedia('1-10/jul', list[18]),
                  PlotMedia('11-20/jul', list[19]),
                  PlotMedia('21-31/jul', list[20]),
                  PlotMedia('1-10/ago', list[21]),
                  PlotMedia('11-20/ago', list[22]),
                  PlotMedia('21-31/ago', list[23]),
                  PlotMedia('1-10/set', list[24]),
                  PlotMedia('11-20/set', list[25]),
                  PlotMedia('21-30/set', list[26]),
                  PlotMedia('1-10/out', list[27]),
                  PlotMedia('11-20/out', list[28]),
                  PlotMedia('21-31/out', list[29]),
                  PlotMedia('1-10/nov', list[30]),
                  PlotMedia('11-20/nov', list[31]),
                  PlotMedia('21-30/nov', list[32]),
                  PlotMedia('1-10/dez', list[33]),
                  PlotMedia('11-20/dez', list[34]),
                  PlotMedia('21-31/dez', list[35]),
                ],
                xValueMapper: (PlotMedia sales, _) => sales.decendio,
                yValueMapper: (PlotMedia sales, _) => sales.risco,
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class PlotMedia {
  PlotMedia(this.decendio, this.risco);
  final String decendio;
  final double risco;
}
