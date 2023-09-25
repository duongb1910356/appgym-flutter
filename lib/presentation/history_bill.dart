import 'package:fitivation_app/components/bills/item_history.dart';
import 'package:fitivation_app/models/bill.model.dart';
import 'package:fitivation_app/models/cart.model.dart';
import 'package:fitivation_app/services/bill.service.dart';
import 'package:flutter/material.dart';

class HistoryBillPage extends StatefulWidget {
  @override
  State<HistoryBillPage> createState() => _HistoryBillPageState();
}

class _HistoryBillPageState extends State<HistoryBillPage> {
  late List<Bill> bills = [];
  final BillService billService = BillService();

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    List<Bill>? billsTemp = await billService.getBillsOfMe();
    setState(() {
      bills = billsTemp!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: Text(
          'Lịch sử thanh toán',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          // child: Column(
          //   children: [ItemHistory(item: bills![0])],
          // ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: bills.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemHistory(item: bills[index]);
            },
          ),
        ),
      ),
    );
  }
}
