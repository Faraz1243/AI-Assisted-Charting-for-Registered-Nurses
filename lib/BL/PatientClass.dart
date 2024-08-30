import 'package:flutter/material.dart';
import 'package:uci/ChatGPT.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../SharedPreferencesHelper.dart';

class PatientClass{
  String name;
  int age;
  int gender;

  PatientClass({required this.name, required this.age, required this.gender});

  static PatientClass fromString(String str){
    final parts = str.split("\$");
    String name = parts[0];
    int age = int.parse(parts[1]);
    int gender = int.parse(parts[2]);
    return PatientClass(name: name, age: age, gender: gender);
  }

  String getGenderText() {
    switch (gender) {
      case 0:
        return "Male";
      case 1:
        return "Female";
      case 2:
        return "Other";
      default:
        return "Unknown";
    }
  }

  @override
  String toString(){
    return "$name\$$age\$$gender";
  }


  Widget getTile(context, Function() setStateCallback){
    final width = MediaQuery.of(context).size.width;

    Color frontColor, backColor;

    switch(gender){
      case 0:
        frontColor = Colors.blue;
        backColor = Colors.blue[100]!;
        break;
      case 1:
        frontColor = Colors.pinkAccent;
        backColor = Colors.pink[50]!;
        break;
      default:
        frontColor = Colors.black;
        backColor = Colors.grey;
    }


    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, "/patientProfile", arguments: this);
          },
          child: Container(
            width: width * 0.8,
            height: width * 0.6,
            margin: EdgeInsets.fromLTRB(width * 0.1, 10, width * 0.1, 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                CircleAvatar(
                  radius: 32,
                  backgroundColor: backColor,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: frontColor,
                  ),
                ),


                // CircleAvatar(
                //   radius: 32,
                //   backgroundColor: Colors.pink[50],
                //   child: widget.pic ?? const Icon(Icons.person, size: 50, color: Colors.pinkAccent),
                // ),

                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Age: ${age}",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.fromLTRB(width * 0.8-10, 20, 20, 10),
            child: PopupMenuButton(itemBuilder: (context)=>[
              PopupMenuItem(
                child: Text("Delete"),
                onTap: (){
                  SnackBar snackBar = const SnackBar(
                    content: Text('Patient deleted'),
                    duration: Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  SharedPrefsHelper.delPatient(name);
                  setStateCallback();
                },
              ),
              PopupMenuItem(
                child: Text("Export", ),
                onTap: (){
                  SnackBar snackBar = const SnackBar(
                    content: Text('Please Wait!'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  exportReport(context);
                },
              ),
            ]),
        ),
      ],
    );
  }

  Future<void> exportReport(context) async {
    var list = await SharedPrefsHelper.getPatientEvents(this.name);
    String allText = list.map((e) => ("time: ${e.time}\n ${e.description}")).join("\n===================\n\n");
    String textReport = await ChatGPTclass.getCharting(allText);
    String csvReport = await ChatGPTclass.getTabularData(allText);

    // check internet connection
    bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      SnackBar snackBar = const SnackBar(
        content: Text('No internet connection'),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    await Navigator.pushNamed(context, "/textReport", arguments: [textReport, csvReport]);
  }

}