import 'package:flutter/material.dart';

class ManagerMenuComponent extends StatelessWidget {
  final Function()? onTap;
  final String? title;
  final IconData? icon;

  const ManagerMenuComponent(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.amber,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue[50],
        ),
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      title: Text('${title}'),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.black45,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.chevron_right_outlined,
            size: 15,
            color: Colors.white,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
