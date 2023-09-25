import 'package:fitivation_app/models/bill.model.dart';
import 'package:fitivation_app/models/cart.model.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:intl/intl.dart';

class DetailTransaction extends StatelessWidget {
  final Bill item;
  const DetailTransaction({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${item.item?.packageFacility?.facility?.name}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                      '- ${MoneyFormatter(amount: item.totalPrice!.toDouble()).output.withoutFractionDigits}',
                      style: Theme.of(context).textTheme.displayLarge)
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Trạng thái'),
                  item.status == true
                      ? Badge(
                          backgroundColor: Color.fromARGB(255, 111, 170, 129),
                          label: Text('Thành công'),
                        )
                      : Badge(
                          backgroundColor: Color.fromARGB(255, 234, 96, 22),
                          label: Text('Chưa hoàn thành'),
                        )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Thời gian'),
                  Text(DateFormat('dd/MM/yyyy').format(item.lastUpdated!))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Mã giao dịch'), Text('${item.paymentIntent}')],
              )
            ],
          ),
        ));
  }
}
