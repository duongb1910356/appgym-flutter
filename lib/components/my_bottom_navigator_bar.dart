import 'package:fitivation_app/models/fitivation.model.dart';
import 'package:fitivation_app/presentation/card_member.dart';
import 'package:fitivation_app/presentation/fitivation_page.dart';
import 'package:fitivation_app/presentation/manager/manager_page.dart';
import 'package:fitivation_app/presentation/profile_page.dart';
import 'package:fitivation_app/provider/model/config.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyBottomNavigationBar extends StatefulWidget {
  int originState = 0;

  MyBottomNavigationBar({required this.originState});

  @override
  MyBottomNavigationBarState createState() => MyBottomNavigationBarState();
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedIndex = widget.originState;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FitivationPage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CardMemberPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ManagerFacilityPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PermissionProvider>(
      builder: (context, permissionProvider, child) {
        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_membership_outlined),
              label: 'Thành viên',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Tôi',
            ),
            if (permissionProvider.hasPermission)
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_history_rounded),
                label: 'Quản lý',
              ),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          onTap: _onItemTapped,
        );
      },
    );
  }
}
