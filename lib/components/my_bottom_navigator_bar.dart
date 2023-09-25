import 'package:fitivation_app/presentation/card_member.dart';
import 'package:fitivation_app/presentation/profile_page.dart';
import 'package:flutter/material.dart';

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
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CardMemberPage()));
        break;
      case 2:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
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
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.orange,
      onTap: _onItemTapped,
    );
  }
}
