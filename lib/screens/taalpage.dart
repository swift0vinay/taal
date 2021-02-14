import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:taal/constants.dart';
import 'package:taal/screens/graph.dart';

class TaalPage extends StatefulWidget {
  final String selectedNote;
  final double selectedFreq;
  TaalPage({this.selectedNote, this.selectedFreq});
  @override
  _TaalPageState createState() => _TaalPageState();
}

class _TaalPageState extends State<TaalPage> with TickerProviderStateMixin {
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
  AnimationController expandController;
  Animation<double> expand;
  @override
  void initState() {
    super.initState();
    isRecording = flutterFft.getIsRecording ?? false;
    frequency = flutterFft.getFrequency ?? 0;
    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    expandController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    expandController.repeat(reverse: true);
    expand = Tween<double>(begin: 0, end: 0).animate(expandController);
    animation = ColorTween(begin: Colors.red, end: Colors.green)
        .animate(animationController);
    expand.addListener(() {
      setState(() {});
    });
    note = flutterFft.getNote;
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      ++counter;
      if (counter == 61) {
        flutterFft.stopRecorder();
        timer.cancel();
        expandController.dispose();
        navigateToNewPage();
      }
      setState(() {});
    });
    _initialize();
    animation.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double h = getHeight(context);
      double w = getWidth(context);
      expand = Tween<double>(begin: w * 0.30, end: w * 0.35)
          .animate(expandController);
    });
  }

  navigateToNewPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Graph(
        plots: plots,
        selectedFreq: this.widget.selectedFreq,
        selectedNote: this.widget.selectedNote,
      );
    }));
  }

  _initialize() async {
    print("Starting recorder...");
    await flutterFft.startRecorder();
    print("Recorder started.");
    setState(() => isRecording = flutterFft.getIsRecording);
    flutterFft.onRecorderStateChanged.listen(
      (data) => {
        if (data != null)
          {
            frequency = data[1],
            plots.add(frequency),
            note = data[2],
            if (frequency >= freqMap[this.widget.selectedNote][0] &&
                frequency <= freqMap[this.widget.selectedNote][1])
              {
                animationController.forward(),
              }
            else
              {
                animationController.reverse(),
              },
            flutterFft.setNote = note,
            flutterFft.setFrequency = frequency,
          }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // flutterFft.stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    double w = getWidth(context);
    print('$counter ${plots.length} $plots');
    return WillPopScope(
      onWillPop: () async {
        animationController.dispose();
        expandController.dispose();
        flutterFft.stopRecorder();
        _timer.cancel();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: white,
          body: Container(
            height: h,
            child: Column(
              children: [
                Container(
                  height: h * 0.25,
                  width: w,
                  child: Center(
                    child: Container(
                      width: expand.value,
                      height: expand.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${61 - counter}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 60,
                                ),
                              ),
                              TextSpan(
                                text: " s",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    height: h * 0.05,
                    child: Text(
                      "Note Set \u266B \u266B : ${this.widget.selectedNote}",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: w,
                      child: Row(
                        children: [
                          Expanded(
                            child: PhysicalModel(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.transparent,
                              shadowColor: black,
                              child: Container(
                                margin: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: animation.value,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Current Note",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: "$note",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 30,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: PhysicalModel(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.transparent,
                              shadowColor: black,
                              child: Container(
                                margin: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: animation.value,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Current Freq",
                                        style: TextStyle(
                                          color: white,
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text:
                                                "${frequency.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 30,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(
                                          text: " Hz",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: h * 0.2,
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: Image.asset('assets/gif.gif',
                        alignment: Alignment.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
