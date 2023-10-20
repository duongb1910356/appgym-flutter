import 'package:fitivation_app/components/chart/invidualdata.dart';

class BarData {
  Map<String, dynamic> rawData;

  BarData({required this.rawData});

  List<ChartData> chartData = [];

  void initDataChart() {
    rawData.forEach((key, value) {
      chartData.add(ChartData(key, value));
    });
  }
}
