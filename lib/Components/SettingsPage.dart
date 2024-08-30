import 'package:flutter/material.dart';

import '../SharedPreferencesHelper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key,});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}




class _SettingsPageState extends State<SettingsPage> {
  var _dark = false;
  String name="";
   void getName() async {
     name = await SharedPrefsHelper.getName();
     setState(() {

     });
   }

   @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 20),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ],
                  ),
                  //line separator
                  const Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              ),

              //Dark Theme
              ListTile(
                title: const Text('Dark Theme'),
                leading: const Icon(Icons.dark_mode),
                trailing: Switch(
                  value: _dark,
                  onChanged: (value) {
                    setState(() {
                      _dark = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Change Pin'),
                leading: const Icon(Icons.password),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                title: const Text('Notifications'),
                leading: const Icon(Icons.notifications),
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              ListTile(
                title: const Text('Privacy'),
                leading: const Icon(Icons.privacy_tip),
                onTap: () {
                  Navigator.pushNamed(context, '/privacy');
                },
              ),
              ListTile(
                title: const Text('Security'),
                leading: const Icon(Icons.security),
                onTap: () {
                  Navigator.pushNamed(context, '/security');
                },
              ),
              ListTile(
                title: const Text('About'),
                leading: const Icon(Icons.info),
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
