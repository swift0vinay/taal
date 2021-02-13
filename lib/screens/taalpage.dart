import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:taal/constants.dart';
import 'package:taal/screens/graph.dart';

class TaalPage extends StatefulWidget {
  @override
  _TaalPageState createState() => _TaalPageState();
}

class _TaalPageState extends State<TaalPage>
    with SingleTickerProviderStateMixin {
  List<Color> colors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.purpleAccent,
    Colors.yellow,
    Colors.orange
  ];
  double frequency;
  String note;
  bool isRecording;
  FlutterFft flutterFft = new FlutterFft();
  final Random random = Random();
  Color prevColor;
  Color nextColor;
  Timer _timer;
  List<double> plots = [];
  int counter = 1;
  AnimationController animationController;
  Animation<Color> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isRecording = flutterFft.getIsRecording;
    frequency = flutterFft.getFrequency;
    prevColor = colors[random.nextInt(colors.length)];
    nextColor = colors[random.nextInt(colors.length)];
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = Tween<Color>(begin: prevColor, end: nextColor)
        .animate(animationController);
    note = flutterFft.getNote;

    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      ++counter;
      plots.add(0);
      if (counter == 61) {
        timer.cancel();
        navigateToNewPage();
      }
      setState(() {});
    });
    _initialize();
    animation.addListener(() {
      setState(() {});
    });
  }

  navigateToNewPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Graph(plots: plots);
    }));
  }

  _initialize() async {
    print("Starting recorder...");
    await flutterFft.startRecorder();
    print("Recorder started.");
    setState(() => isRecording = flutterFft.getIsRecording);
    flutterFft.onRecorderStateChanged.listen(
      (data) => {
        frequency = data[1],
        plots.add(frequency),
        note = data[2],
        prevColor = nextColor,
        nextColor = colors[random.nextInt(colors.length)],
        animation = Tween<Color>(begin: prevColor, end: nextColor)
            .animate(animationController),
        animationController.forward(),
        flutterFft.setNote = note,
        flutterFft.setFrequency = frequency,
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flutterFft.stopRecorder();
    animationController.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    double w = getWidth(context);
    print('$counter $plots');
    return Scaffold(
      body: Container(
        height: h,
        child: Column(
          children: [
            Container(
              height: h * 0.3,
              width: w,
              color: animation.value,
              child: Center(
                child: Text(
                  "${61 - counter}",
                  style: TextStyle(
                      color: white, fontSize: 50, fontStyle: FontStyle.italic),
                ),
              ),
            ),
            Container(
              height: h * 0.7,
              color: animation.value,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "${frequency.toStringAsFixed(2)}",
                        style: TextStyle(color: white, fontSize: 30),
                      ),
                      TextSpan(
                        text: "Hz",
                        style: TextStyle(color: white, fontSize: 20),
                      ),
                    ]),
                  ),
                  Text(
                    "$note",
                    style: TextStyle(
                      color: white,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
