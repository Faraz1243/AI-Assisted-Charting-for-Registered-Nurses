import 'package:flutter/material.dart';
import 'Components/Components.dart';

class HomeNav extends StatefulWidget {
  String name;
  HomeNav({super.key, required this.name});

  @override
  State<HomeNav> createState() => _HomeNavState();
}


class _HomeNavState extends State<HomeNav> {
  late String name ;

  var list = [];
  var idx = 0;
  Widget? bodyy;

  @override
  void initState() {
    name = widget.name;
    list = [
      HomePage(),
      PatientsPage(),
      SettingsPage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: bodyy ?? HomePage(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        currentIndex: idx,
        onTap: (index) {
          setState(() {
            idx = index;
            switch(idx){
              case 0:
                bodyy = HomePage();
                break;
              case 1:
                bodyy = PatientsPage();
                break;
              case 2:
                bodyy = SettingsPage();
                break;
            }

          });
        },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ]
      ),
    );
  }
}
