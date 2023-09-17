import 'package:flutter/material.dart';

class HeaderHomePage extends StatefulWidget {
  const HeaderHomePage({Key? key}) : super(key: key);

  @override
  State<HeaderHomePage> createState() => _HeaderHomePage();
}

class _HeaderHomePage extends State<HeaderHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                // margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0x19000000)),
                    color: Color(0x33d9d9d9),
                    borderRadius: BorderRadius.circular(50)),
                child: TextFormField(
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm...',
                    fillColor: Color(0x33d9d9d9),
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.search_outlined,
              size: 30,
              color: Color.fromARGB(255, 88, 63, 63),
              weight: 0.5,
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(
              Icons.shopping_cart_outlined,
              size: 30,
              color: Color.fromARGB(255, 88, 63, 63),
              weight: 0.5,
            )
          ],
        ),
      ],
    );
  }
}
