import 'package:flutter/material.dart';
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
    return WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home()));
          return Future.value(true);
        },
        child: Scaffold(body: Text("SAKfiasdfhefih")));
  }
}
