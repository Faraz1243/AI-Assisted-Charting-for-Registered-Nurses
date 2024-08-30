import 'package:flutter/material.dart';

class PatientTile extends StatefulWidget {
  final String patient;
  final int age;
  final Image? pic;
  final int gender;

  PatientTile({super.key, required this.patient, required this.age,required this.gender, this.pic});

  @override
  State<PatientTile> createState() => _PatientTileState();
}

class _PatientTileState extends State<PatientTile> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
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
                  backgroundColor: widget.gender == 1 ? Colors.blue[100] : Colors.pink[50],
                  child: widget.pic ?? Icon(
                      Icons.person,
                      size: 50,
                      color: widget.gender == 1 ? Colors.blue : Colors.pinkAccent,
                  ),
                ),

              const SizedBox(height: 8),
              Text(
                widget.patient,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "Age: ${widget.age}",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(width * 0.8, 25, 10, 10),
            child: IgnorePointer(
              ignoring: false,
              child: PopupMenuButton<String>(
                onSelected: (String value) {
                  // Handle menu item selection here
                  if (value == "s") {
                    // Execute code when 's' is selected
                    print("Menu item 's' selected");
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: "s",
                      child: Text("s"),
                    ),
                  ];
                },
              ),
            ),
        ),
      ],
    );
  }
}
