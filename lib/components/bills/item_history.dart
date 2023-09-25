import 'package:fitivation_app/components/bills/detail_transaction.dart';
import 'package:fitivation_app/models/bill.model.dart';
import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class ItemHistory extends StatelessWidget {
  final Bill item;
  ItemHistory({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return DetailTransaction(
                item: item,
              );
            });
      },
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 20, left: 25, right: 25),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.03),
                      spreadRadius: 10,
                      blurRadius: 3)
                ]),
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 30, right: 20, bottom: 10),
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 234, 227, 227),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Icon(Icons.payment_rounded)),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Container(
                    width: (MediaQuery.of(context).size.width - 90) * 0.7,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Gửi",
                        //   style: Theme.of(context).textTheme.displayLarge,
                        // ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${item.item?.packageFacility?.name}',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  inherit: true, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${MoneyFormatter(amount: item.totalPrice!.toDouble()).output.withoutFractionDigits} đ",
                          style: Theme.of(context).textTheme.displayLarge,
                        )
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
