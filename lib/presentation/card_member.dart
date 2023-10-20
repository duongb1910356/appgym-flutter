import 'package:fitivation_app/components/header_homepage.dart';
import 'package:fitivation_app/components/my_bottom_navigator_bar.dart';
import 'package:fitivation_app/models/subscription.model.dart';
import 'package:fitivation_app/services/subscription.service.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class CardMemberPage extends StatefulWidget {
  @override
  State<CardMemberPage> createState() => _CardMemberPageState();
}

class _CardMemberPageState extends State<CardMemberPage> {
  final SubscriptionService subscriptionService = SubscriptionService();
  late List<Subsciption> subscriptions = [];
  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    List<Subsciption>? subscriptionTemp =
        await subscriptionService.getSubscriptionOfMe();
    setState(() {
      subscriptions = subscriptionTemp!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: HeaderHomePage(),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 70,
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: subscriptions.length,
        itemBuilder: (BuildContext context, int index) {
          return CardMemberDetail(
            subsciption: subscriptions[index],
          );
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(originState: 1),
    );
  }
}

class CardMemberDetail extends StatelessWidget {
  final Subsciption subsciption;

  const CardMemberDetail({required this.subsciption});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Card(
        color: Colors.transparent,
        elevation: 8.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 236, 173, 133),
                Color.fromARGB(255, 151, 150, 153)
              ], // Gradient màu tím
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15.0), // Độ cong của nền
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${subsciption.packageFacility?.facility?.name}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${subsciption.packageFacility?.name}'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      QrImageView(
                        data: '${subsciption.id}',
                        version: QrVersions.auto,
                        size: 100.0,
                        // padding: EdgeInsets.zero,
                        backgroundColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${subsciption.user?.displayName}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                          'EXP: ${DateFormat('dd/MM/yyyy').format(subsciption.expireDay!)}'),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
