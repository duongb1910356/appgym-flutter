import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String textButton;
  final Function()? onTap;

  const MyButton({super.key, required this.onTap, required this.textButton});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xa326a8f2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            textButton,
            style: const TextStyle(
                color: Color(0xffffffff),
                fontWeight: FontWeight.w600,
                fontSize: 21),
          ),
        ),
      ),
    );
  }
}
