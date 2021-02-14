import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taal/constants.dart';
import 'package:taal/models/freqModel.dart';
import 'package:taal/screens/frequncySampling.dart';
import 'package:taal/screens/taalpage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  AnimationController expandController;
  Animation<double> expanded;
  bool go = false;
  String dSelected;
  double fSelected;
  String def = 'Select Note \u266B';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    go = false;
    dropDownItems.add(DropdownMenuItem<String>(
      child: Text(def, style: TextStyle()),
      value: def,
    ));
    freqMap.forEach((key, value) {
      dropDownItems.add(new DropdownMenuItem<String>(
        child: Text(key),
        value: key,
      ));
      freqModels.add(new FreqModel(
        freq: key,
        low: value[0],
        high: value[1],
      ));
    });
    dSelected = dropDownItems[0].value;
    fSelected = 0.0;
    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = Tween<double>(begin: 10, end: 0).animate(animationController);
    expandController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    expandController.repeat(reverse: true);
    expanded = Tween<double>(begin: 0, end: 0).animate(expandController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double h = getHeight(context);
      double w = getWidth(context);
      animation =
          Tween<double>(begin: 10, end: h * 1.2).animate(animationController);
      expanded = Tween<double>(begin: w * 0.2, end: w * 0.25)
          .animate(expandController);
      expanded.addListener(() {
        setState(() {});
      });
      animation.addListener(() {
        setState(() {
          if (animation.status == AnimationStatus.completed) {
            navigateTo();
          }
        });
      });
    });
  }

  navigateTo() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaalPage(selectedNote: dSelected, selectedFreq: fSelected);
    })).then((val) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      go = false;
      dSelected = dropDownItems[0].value;
      fSelected = 0.0;
      animationController = AnimationController(
          duration: Duration(milliseconds: 1500), vsync: this);
      animation = Tween<double>(begin: 10, end: 0).animate(animationController);
      double h = getHeight(context);
      double w = getWidth(context);
      if (w < h) {
        double temp = h;
        h = w;
        w = temp;
      }
      print('!!!!!!!!!!!!!!!!!!$h $w');
      expanded = Tween<double>(begin: h * 0.2, end: h * 0.25)
          .animate(expandController);
      expanded.addListener(() {
        setState(() {});
      });
      expandController.repeat(reverse: true);
      animation =
          Tween<double>(begin: 10, end: w * 1.2).animate(animationController);
      animation.addListener(() {
        setState(() {
          if (animation.status == AnimationStatus.completed) {
            navigateTo();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
    expandController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    double w = getWidth(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: h,
              width: w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/doodle1.png'),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [Color(0xffbdc3c7), Color(0xff2c3e50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Positioned(
              left: w * 0.25,
              top: h * 0.15,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 1000),
                opacity: go ? 0 : 1,
                child: ClipOval(
                  child: Container(
                    height: w * 0.2,
                    width: w * 0.5,
                    color: primary,
                    child: Center(
                      child: Text(
                        "TAAL",
                        style: TextStyle(
                          fontSize: 30,
                          color: white,
                          fontFamily: "Vendata",
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: w * 0.1,
              top: h * 0.45,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 1000),
                opacity: go ? 0 : 1,
                child: Container(
                  width: w * 0.8,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: dropDownItems,
                            dropdownColor: white,
                            selectedItemBuilder: (context) {
                              return List.generate(
                                dropDownItems.length,
                                (i) => Container(
                                  child: Center(
                                    child: Text(dropDownItems[i].value,
                                        style: TextStyle(color: white)),
                                  ),
                                ),
                              );
                            },
                            iconEnabledColor: white,
                            value: dSelected,
                            onChanged: (val) {
                              setState(() {
                                dSelected = val;
                                fSelected = freqMap[dSelected][0];
                              });
                            },
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.info, color: white),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SamplingTable(),
                                  ));
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: animation.value,
              left: (w - expanded.value) / 2,
              child: InkWell(
                onTap: () {
                  if (dSelected == def) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Alert!!"),
                            content: Text("Please select a Note!!"),
                            actions: [
                              FlatButton(
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          );
                        });
                  } else {
                    go = true;
                    expandController.reset();
                    // expandController.reverse();
                    animationController.forward();
                  }
                },
                borderRadius: BorderRadius.circular(30.0),
                child: PhysicalModel(
                  elevation: 20.0,
                  shadowColor: black,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    height: expanded.value,
                    width: expanded.value,
                    child: Center(
                      child: Text(
                        "GO",
                        style: TextStyle(
                          color: white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
