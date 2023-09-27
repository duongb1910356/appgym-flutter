import 'package:flutter/material.dart';

class MyDropList extends StatefulWidget {
  final void Function(String) onItemSelected;
  const MyDropList({Key? key, required this.onItemSelected}) : super(key: key);

  @override
  State<MyDropList> createState() => _MyDropList();
}

class _MyDropList extends State<MyDropList> {
  late String valueChoose = 'ROLE_USER';
  List<String> listItem = ["ROLE_USER", "ROLE_OWNER"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white, // Màu sắc của border
          width: 1.0, // Độ dày của border
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(8),
        hint: const Text('Chọn vai trò'),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 32,
        isExpanded: true,
        underline: const SizedBox(),
        padding: const EdgeInsets.only(left: 10),
        style: const TextStyle(
          color: Color.fromARGB(255, 86, 65, 114),
          fontSize: 16,
        ),
        value: valueChoose,
        onChanged: (newValue) {
          setState(() {
            valueChoose = newValue.toString();
          });
          widget.onItemSelected(newValue!);
        },
        items: listItem.map((valueItem) {
          return DropdownMenuItem(
              value: valueItem, child: Text(valueItem.toString()));
        }).toList(),
      ),
    );
  }
}
