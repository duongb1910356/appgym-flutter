import 'dart:math';

import 'package:fitivation_app/components/chart/bardata.dart';
import 'package:fitivation_app/components/chart/invidualdata.dart';
import 'package:fitivation_app/components/shared/square_tile.dart';
import 'package:fitivation_app/presentation/cart_page.dart';
import 'package:fitivation_app/services/bill.service.dart';
import 'package:fitivation_app/services/fitivation.service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SatisfiedPage extends StatefulWidget {
  const SatisfiedPage({super.key});

  @override
  State<SatisfiedPage> createState() => _SatisfiedPageState();
}

class _SatisfiedPageState extends State<SatisfiedPage> {
  final BillService billService = BillService();
  final FitivationService fitivationService = FitivationService();

  List<ChartData>? data;
  late TooltipBehavior _tooltip;

  Future<List<ChartData>?> initDataChart() async {
    Map<String, dynamic>? rawData = await billService.satifiedIncome();
    BarData barData = BarData(rawData: rawData!);
    barData.initDataChart();
    // setState(() {
    //   data = barData.chartData;
    // });

    return barData.chartData;
  }

  Future<List<ChartData>?> initDataChartSubscription() async {
    Map<String, dynamic>? rawDataCountSubscription =
        await fitivationService.getSubscriptionsCountByFacilityOwnedByUser();
    BarData barDataSubscription = BarData(rawData: rawDataCountSubscription!);

    barDataSubscription.initDataChart();

    print(
        "barDataSubscription.chartData ${barDataSubscription.chartData[1].x}");

    return barDataSubscription.chartData;
  }

  @override
  void initState() {
    super.initState();
    initDataChart();
    initDataChartSubscription();
    _tooltip = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SquareTile(imagePath: 'lib/assets/logo_app_gym.png'),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BEEGYM",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
                  );
                },
                child: const Icon(
                  IconData(0xe57f, fontFamily: 'MaterialIcons'),
                  size: 25,
                  color: Color.fromARGB(255, 88, 63, 63),
                  weight: 0.5,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            FutureBuilder(
                future: initDataChart(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ChartData>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Ví dụ: Hiển thị vòng tròn tiến trình
                  } else {
                    return SizedBox(
                        height: 250,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          primaryYAxis: NumericAxis(
                              minimum: 0,
                              interval: 10,
                              title: AxisTitle(
                                  text: "Triệu",
                                  alignment: ChartAlignment.far)),
                          tooltipBehavior: _tooltip,
                          series: <ChartSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                                dataSource: snapshot.data!,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                name: "Tổng (triệu)",
                                color: Colors.blue)
                          ],
                        ));
                  }
                }),
            Text('Biểu đồ doanh thu tháng'),
            Divider(
              thickness: sqrt1_2,
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: initDataChartSubscription(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ChartData>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Ví dụ: Hiển thị vòng tròn tiến trình
                  } else {
                    return SizedBox(
                        height: 250,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                              labelIntersectAction:
                                  AxisLabelIntersectAction.wrap),
                          primaryYAxis: NumericAxis(
                              minimum: 0,
                              interval: 5,
                              name: "Người",
                              title: AxisTitle(
                                  text: "Người",
                                  alignment: ChartAlignment.far)),
                          tooltipBehavior: _tooltip,
                          series: <ChartSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                                dataSource: snapshot.data!,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                name: "Tổng (triệu)",
                                color: Colors.blue)
                          ],
                        ));
                  }
                }),
            Text('Biểu đồ lượt đăng ký phòng tập'),
          ],
        ),
      ),
    );
  }
}
