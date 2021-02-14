import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taal/models/DataModel.dart';
import 'package:taal/screens/home.dart';

class Graph extends StatefulWidget {
  List<double> plots;
  Graph({this.plots});
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    List<DataModel> dm = [];
    for(int i=0;i<widget.plots.length;i++){
      dm.add(DataModel(x:(i+1).toDouble(),y:widget.plots[i]));
    }
    return WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          return Future.value(true);
        },
        child: Scaffold(
          body: Container(
            child: SfCartesianChart(
              primaryXAxis : CategoryAxis(
                title: AxisTitle(text : "Time(s)")

              ),
              title: ChartTitle(text : 'Frequency(Hz) vs Time(s) Analysis'),
              legend: Legend(isVisible: true),
              series: <LineSeries<DataModel,double>>[
                LineSeries<DataModel,double>(
                  dataSource: dm,
                  xValueMapper: (DataModel d,_) => d.x,
                  yValueMapper : (DataModel d,_) => d.y,
                  dataLabelSettings: DataLabelSettings(isVisible: true)

                )
              ]

            ),
          )
        ));
  }
}
