import 'dart:math';
import 'package:taal/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taal/models/DataModel.dart';
import 'package:taal/screens/home.dart';
import 'package:flutter/services.dart';

class Graph extends StatefulWidget {
  List<double> plots;
  Graph({this.plots});
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
  ]);
  }
  @override
  Widget build(BuildContext context) {
    List<DataModel> dm = [];
    print("RRRRRRr");
    print(widget.plots.length);
    for(int i=0;i<widget.plots.length;i++){
      if(widget.plots[i]==0.0 && i!=0){
        dm.add(DataModel(x:(i+1).toDouble(),y:widget.plots[i-1]));
        widget.plots[i] = widget.plots[i-1];
        continue;
      }
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
                isVisible: false,
                title: AxisTitle(text : "Time(s)")

              ),
              primaryYAxis: CategoryAxis(
                title: AxisTitle(text : "Frequency(Hz)"),
                
              ),
              title: ChartTitle(text : 'Frequency(Hz) vs Time(s) Analysis'),
              legend: Legend(
                position: LegendPosition.top,
                isVisible: true,
                //title: LegendTitle(text : "Notes"),
              
              ),
              series: <LineSeries<DataModel,double>>[
                LineSeries<DataModel,double>(
                  legendItemText: "Actual frequency",
                  dataSource: dm,
                  xValueMapper: (DataModel d,_) => d.x,
                  yValueMapper : (DataModel d,_) => d.y,
                 // dataLabelSettings: DataLabelSettings(isVisible: true)

                ),
                LineSeries<DataModel,double>(
                  legendItemText: "$noteSel frequency",
                  dataSource: dm,
                  xValueMapper: (DataModel d,_) => d.x,
                  yValueMapper : (DataModel d,_) => selectedFreq,
                 // dataLabelSettings: DataLabelSettings(isVisible: true)

                )
              ]

            ),
          )
        ));
  }
}
