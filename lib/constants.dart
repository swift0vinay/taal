import 'package:flutter/material.dart';

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Color white = Colors.white;
Color primary = Colors.blue[900];

Map<String,List<double>> freq = {
  "C0" : [16.35,17.31],
  "C#0 / Db0" : [17.32,18.34],
  "D0" : [18.35,19.44],
  "D#0 / Eb0" : [19.45,20.59],
  "E0" : [20.60,21.82],
  "F0" : [21.83,23.11],
  "F#0 / Gb0" : [23.12,24.49],
  "G0" : [24.5,25.95],
  "G#0 / Ab0" : [25.96,27.49],
  "A0" : [27.5,29.13],
  "A#0 / Bb0" : [29.14,30.86],
  "C1" : [30.87,32.69],
  "C#1 / Db1" : [34.65,36.70],
  "D1" : [36.71,38.88],
  "D#1/Eb1" : [38.89,41.19] ,
  "E1" : [41.20,43.64],
  "F1" : [43.65,46.24],
  "F#1/Gb1" : [46.25,48.99],
  "G1" : [49.00,51.90],
  "G#1/Ab1" : [51.91,54.99],
  "A1" : [55.00,58.26],
  "A#1/Bb1" : [58.27,61.73],
  "B1" : [61.74,65.40],
  "C2" : [65.41,69.29],
  "C#2/Db2" : [69.30,73.41],
  "D2" : [73.42,77.77],
  "D#2/Eb2" : [77.78,82.40],
  "E2" : [82.41,87.30],
  "F2" : [87.31,92.49],
  "F#2/Gb2" : [92.5,97.99],
  "G2" : [98.00,103.82],
  "G2#/Ab2" : [103.83,109.99],
  "A2" : [110.0,116.53],
  "A#2,Bb2" : [116.54,123.46],
  "B2" : [123.47,130.80],
  "C3" : [130.81,138.58],
  "C#3/Db3" : [138.59,146.82],
  "D3" : [146.83,155.55],
  "D#3/Eb3" : [155.56,164.80],
  "E3" : [164.81,174.60],
  "F3" : [174.61,184.99],
  "F#3/Gb3" : [185.00,195.99],
  "G3" : [196.00,207.64],
  "G#3/Ab3" : [207.65,219.99],
  "A3" : [220.00,233.07],
  "A#3/Bb3" : [233.08,246.93],
  "B3" : [246.94,261.62],
  "C4" : [261.63,277.17],
  "C#4/Db4" : [277.18,293.65],
  "D4" : [293.66,311.12],
  "D#4/Eb4" : [311.13,329.62],
  "E4" : [329.63,349.22],
  "F4" : [349.23,369.98],
  "F#4,Gb4" : [369.99,391.99],
  "G4" : [392.00,415.29],
  "G#4/Ab4" : [415.30,439.99],
  "A4" : [440.00,466.15],
  "A#4/Bb4" : [466.16,493.87],
  "B4" : [493.88,523.24],
  "C5" : [523.25,554.36],
  "C#5/Db5" : [554.37,587.32],
  "D5" : [587.33,622.24],
  "D#5/Eb5" : [622.25,659.24],
  "E5" : [659.25,698.45],
  "F5" : [698.46,739.98],
  "F#5/Gb5" : [739.99,783.98],
  "G5" : [783.99,830.60],
  "G#5/Ab5" : [830.61,879.99],
  "A5" : [880.00,932.32],
  "A#5,Bb5" : [932.33,987.77],
  "B5" : [987.77,1046.59],
  "C6" : [1046.50,1108.72],
  "D6" : [1174.66,1244.50],
  "D#6/Eb6" : [1244.51,1318.50],
  "E6" : [1318.51,1396.90],
  "F6" : [1396.91,1479.97],
  "F#6/Gb6" : [1479.98,1567.97],
  "G6" : [1567.98,1661.21],
  "G#6/Ab6" : [1661.22,1759.99],
  "A6" : [1760,1864.65],
  "A#6/Bb6" : [1864.66,1975.52],
  "B6" : [1975.53,2092.99],
  "C7" : [2093.00,2217.45],
  "C#7/Db7" : [2217.46,2349.32],
  "D#7/Eb7" : [2489.02,2647.01],
  "E7" : [2637.02,2793.82],
  "F7" : [2793.83,2959.95],
  "F#7/Gb7" : [2959.96,3135.95],
  "G#7/AB7" : [3322.44,3519.99],
  "A7" : [3520.00,3729.30],
  "A#7/BB7" : [3729.31,3951.06],
  "B7"  : [3951.07,4186.00],
  "C8" : [4186.01,4434.91],
  "C#8/Db8" : [4434.92,4698.63],
  "D8" : [4698.63,4978.03],
  "D#8/Eb8" : [4978.03/5274.03],
  "E8" : [5274.04,5587.65],
  "F8" : [5587.65,5919.90],
  "F#8/Gb8" : [5919.91,6271.92],
  "G8" : [6271.93,6644.87],
  "G#8,Ab8" : [6644.88,7039.99],
  "A8" : [7040.00,7458.61],
  "A#8/Bb8" : [7458.62,7902.12],
  "B8" : [7902.13,8000.00], 
  } ;
