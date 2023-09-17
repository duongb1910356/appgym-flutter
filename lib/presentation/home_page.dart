// import 'dart:math';

// import 'package:fitivation_app/components/header_homepage.dart';
// import 'package:fitivation_app/components/item_component.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   final List<Map<String, dynamic>> listItem = [
//     {
//       "id": {"timestamp": 1693204202, "date": "2023-08-28T06:30:02.000+00:00"},
//       "ownerId": null,
//       "address": {
//         "province": "tỉnh Kiên Giang",
//         "district": "thành phố Rạch Gía",
//         "ward": "phường An Bình",
//         "street": "106 Lê Quý Đôn"
//       },
//       "slugAddress": null,
//       "location": null,
//       "avagerstar": 0.0,
//       "describe": "asgdsgsddhdfh",
//       "name": "City gym 2",
//       "phone": null,
//       "email": null,
//       "distance": 72.96566411467062
//     },

//     {
//       "id": {"timestamp": 1693204203, "date": "2023-08-28T06:30:02.000+00:00"},
//       "ownerId": null,
//       "address": {
//         "province": "tỉnh Kiên Giang",
//         "district": "thành phố Rạch Gía",
//         "ward": "phường An Bình",
//         "street": "106 Lê Quý Đôn"
//       },
//       "slugAddress": null,
//       "location": null,
//       "avagerstar": 0.0,
//       "describe": "asgdsgsddhdfh",
//       "name": "City gym 2",
//       "phone": null,
//       "email": null,
//       "distance": 72.96566411467062
//     },
//     // Thêm các mục giả mạo khác nếu cần
//   ];

//   final List<String> entries = <String>['A', 'B', 'C'];
//   final List<int> colorCodes = <int>[600, 500, 100];

//   HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//           child: HeaderHomePage(),
//         ),
//         backgroundColor: Colors.white,
//         toolbarHeight: 70,
//       ),
//       body: ListView(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(15),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//             ),
//             child: Column(
//               children: [
//                 const Divider(
//                   color: Color.fromARGB(106, 217, 217, 217),
//                   thickness: 2.0,
//                 ),
//                 ItemConponet(),
//                 SingleChildScrollView(
//                   child: Column(
//                     children: listItem.map((item) {
//                       return ItemConponet();
//                     }).toList(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Tôi')
//       ]),
//     );
//   }
// }
