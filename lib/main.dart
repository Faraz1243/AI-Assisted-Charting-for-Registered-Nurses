import 'package:flutter/material.dart';
import 'package:uci/Components/Components.dart';
import 'package:uci/SharedPreferencesHelper.dart';
import "./HomeNav.dart";
import 'BL/PatientClass.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String name = await SharedPrefsHelper.getName();
  runApp( MyApp(name: name,));
}

class MyApp extends StatelessWidget {
  final String name;
  const MyApp({super.key, required this.name});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, surface: Colors.white70),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            // return MaterialPageRoute(builder: (context) => Animationn());
            if(name == ""){
              return MaterialPageRoute(builder: (context) => const Wellcome());
            }
            return MaterialPageRoute(builder: (context) => HomeNav(name:name));
          case '/addPatient':
            return MaterialPageRoute(builder: (context) => const AddPatient());
          case '/patientProfile':
            final patient = settings.arguments
                as PatientClass; // Cast the arguments to PatientClass
            return MaterialPageRoute(
              builder: (context) => PatientProfile(patient: patient),
            );
          case '/addEvent':
            String micRec =  settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => AddEvent(micRec: micRec,),
            );
          case '/textReport':
            List<dynamic> args =  settings.arguments as List<dynamic>;
            return MaterialPageRoute(
              builder: (context) => TextReport(report: args[0], csv:args[1]),
            );
          default:
            return MaterialPageRoute(builder: (context) => HomeNav(name: name,));
        }
      },
    );
  }
}
