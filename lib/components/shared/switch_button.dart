import 'package:fitivation_app/provider/model/config.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwitchExample extends StatefulWidget {
  final Function()? taskSwitch;

  const SwitchExample({required this.taskSwitch});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light1 = false;

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
        builder: (context, permissionProvider, child) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Switch(
            thumbIcon: thumbIcon,
            value: permissionProvider.hasPermission,
            onChanged: (bool value) {
              setState(() {
                light1 = value;
              });
              widget.taskSwitch!();
            },
          ),
        ],
      );
    });
  }
}
