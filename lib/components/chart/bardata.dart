import 'package:fitivation_app/components/chart/invidualdata.dart';

class BarData {
  Map<String, dynamic> rawData;

  BarData({required this.rawData});

  List<ChartData> chartData = [];

  void initDataChart() {
    try {
      rawData.forEach((key, value) {
        chartData.add(ChartData(key, value));
      });
    } catch (e) {
      print("Error init data chart ${e}");
      return null;
    }
  }
}
