import 'package:fitivation_app/components/shared/my_droplist.dart';
import 'package:fitivation_app/models/cart.model.dart';
import 'package:fitivation_app/services/subscription.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

class CartItem extends StatefulWidget {
  final Item item;
  Function()? deleteItemFromCart;

  Function(String time)? handleTimeRegister;

  CartItem(
      {required this.item,
      required this.deleteItemFromCart,
      required this.handleTimeRegister});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  String? selectedValue = '6am - 9am';
  Map<String, double>? dataMap;
  final SubscriptionService subscriptionService = SubscriptionService();

  // handleTimeRegister(String? newValue) {
  //   setState(() {
  //     selectedValue = newValue;
  //   });
  //   print("selectd value ${selectedValue}");
  // }

  void _initializeData() async {
    dynamic dataList = await subscriptionService
        .getSubscriptionWithTerm(widget.item.packageFacility!.id!);

    if (dataList.length != 0) {
      Map<String, double> subscriptionSummaryTerm = {};

      for (var item in dataList) {
        String timeRegister = item["timeRegister"];
        double count = item["count"].toDouble();

        subscriptionSummaryTerm[timeRegister] = count;
      }
      setState(() {
        dataMap = subscriptionSummaryTerm;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 6, 10, 5),
      width: double.infinity,
      // height: 104,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                width: 91,
                height: 91,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    "${dotenv.env['BASE_URL']}/api/file/${widget.item.packageFacility?.facility?.images?[0]['name']}",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 6, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                      child: Text(
                        '${widget.item.packageFacility?.facility?.name}',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 18),
                      child: Text(
                        '${widget.item.packageFacility!.facility?.address?.street} ${widget.item.packageFacility!.facility?.address?.ward} ${widget.item.packageFacility!.facility?.address?.district} ${widget.item.packageFacility!.facility?.address?.province}',
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Text(
                      '${MoneyFormatter(amount: ((widget.item.packageFacility!.basePrice ?? 0) * (widget.item.packageFacility!.type ?? 0)).toDouble()).output.withoutFractionDigits}',
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                    Row(
                      children: [
                        Text(
                            '${MoneyFormatter(amount: ((widget.item.packageFacility!.basePrice ?? 0) * (widget.item.packageFacility!.type ?? 0) * (1 - (widget.item.packageFacility?.discount ?? 0))).toDouble()).output.withoutFractionDigits} đồng',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Color(0xba6726f2))),
                        SizedBox(
                          width: 10,
                        ),
                        Text('(${widget.item.packageFacility?.type} tháng)'),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.deleteItemFromCart,
                child: Container(
                  width: 12,
                  height: 12,
                  child: Icon(Icons.close),
                ),
              ),
            ],
          ),
          DropdownButton<String?>(
            value: selectedValue,
            items: <String>[
              '6am - 9am',
              '9am - 12am',
              '12am - 3pm',
              '3pm - 6pm',
              '6pm - 9pm'
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
              });
              widget.handleTimeRegister!(newValue!);
            },
          ),
          if (dataMap != null)
            PieChart(
              dataMap: dataMap!,
              chartRadius: 150,
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
            ),
        ],
      ),
    );
  }
}
