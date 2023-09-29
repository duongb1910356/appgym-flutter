import 'package:flutter/material.dart';

class MyDropList extends StatefulWidget {
  dynamic valueChoose;
  final List<dynamic> listItem;
  final void Function(Object) onItemSelected;
  MyDropList(
      {Key? key,
      required this.valueChoose,
      required this.listItem,
      required this.onItemSelected})
      : super(key: key);

  @override
  State<MyDropList> createState() => _MyDropList();
}

class _MyDropList extends State<MyDropList> {
  // late String valueChoose = 'ROLE_USER';
  // List<String> listItem = ["ROLE_USER", "ROLE_OWNER"];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: DropdownButton<Object>(
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
        value: widget.valueChoose,
        onChanged: (newValue) {
          setState(() {
            widget.valueChoose = newValue!;
          });
          widget.onItemSelected(newValue!);
        },
        items: widget.listItem.map((valueItem) {
          return DropdownMenuItem(
              value: valueItem?.id, child: Text(valueItem?.name));
        }).toList(),
      ),
    );
  }
}
