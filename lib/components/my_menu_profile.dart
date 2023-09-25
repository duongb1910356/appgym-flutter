import 'package:flutter/material.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      title: Text(title),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: IconButton(
          icon: const Icon(
            Icons.chevron_right_outlined,
            size: 18,
            color: Colors.grey,
          ),
          onPressed: onPress,
        ),
      ),
    );
  }
}
