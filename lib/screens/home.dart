import 'package:flutter/material.dart';
import 'package:taal/constants.dart';
import 'package:taal/models/freqModel.dart';
import 'package:taal/screens/taalpage.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  bool go = false;
  String dSelected;
  String def = 'Select Note \u266B';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    go = false;
    dropDownItems.add(DropdownMenuItem<String>(
      child: Text(def, style: TextStyle(color: black)),
      value: def,
    ));
    freqMap.forEach((key, value) {
      dropDownItems.add(new DropdownMenuItem<String>(
        child: Text(key, style: TextStyle(color: black)),
        value: key,
      ));
      freqModels.add(new FreqModel(
        freq: key,
        low: value[0],
        high: value[1],
      ));
    });
    dSelected = dropDownItems[0].value;
    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation = Tween<double>(begin: 10, end: 0).animate(animationController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double h = getHeight(context);
      animation =
          Tween<double>(begin: 10, end: h * 1.2).animate(animationController);

      animation.addListener(() {
        setState(() {
          if (animation.status == AnimationStatus.completed) {
            navigateTo();
          }
        });
      });
    });
  }

  navigateTo() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TaalPage();
    }));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = getHeight(context);
    double w = getWidth(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: h,
            width: w,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/doodle1.png'),
                    fit: BoxFit.cover)),
          ),
          Positioned(
            left: w * 0.25,
            top: h * 0.35,
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
            top: h * 0.55,
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
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: white,
                          ),
                          style: TextStyle(color: white),
                          value: dSelected,
                          onChanged: (val) {
                            setState(() {
                              dSelected = val;
                            });
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.info, color: white),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: animation.value,
            left: w * 0.4,
            child: InkWell(
              onTap: () {
                go = true;
                animationController.forward();
              },
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                height: w * 0.2,
                width: w * 0.2,
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
        ],
      ),
    );
  }
}
