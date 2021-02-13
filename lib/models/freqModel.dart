class FreqModel {
  final String freq;
  final double low;
  final double high;
  FreqModel({this.freq, this.low, this.high});
  String toString() {
    return '$freq $low $high';
  }
}
