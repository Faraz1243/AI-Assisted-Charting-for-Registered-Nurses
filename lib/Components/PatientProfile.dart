import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:uci/BL/EventClass.dart';
import 'package:uci/BL/PatientClass.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:uci/SharedPreferencesHelper.dart';

class PatientProfile extends StatefulWidget {
  final PatientClass patient;
  const PatientProfile({super.key, required this.patient});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {

  late List<EventClass> eventList=[];

  @override
  void initState() {
    loadEvents();
    super.initState();
  }
  void loadEvents()async{
    eventList = await SharedPrefsHelper.getPatientEvents(widget.patient.name);
    setState(() { });
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Profile"),
        actions: [
          IconButton(
              onPressed: ()async {
                if(eventList.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });
                  await widget.patient.exportReport(context);
                  setState(() {
                    _isLoading = false;
                  });
                }
                else{
                SnackBar snackBar = const SnackBar(
                  content: Text("No Evaluation Available!"),
                  duration: const Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              icon: const Icon(
                  Icons.addchart_outlined,
                color: Colors.blue,
              ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // headers
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Name: ${widget.patient.name}",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6,),
                              Text(
                                  "Age: ${widget.patient.age}",
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 6,),
                              Text(
                                "Gender: ${widget.patient.getGenderText()}",
                                style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                              ),
                              ),

                            ]
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Text(
                      "Evaluation Overview",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize:18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"
                    ),
                  ),




                  Column(
                      children:
                      eventList.isNotEmpty && eventList!=null ? List.generate(
                          eventList.length,
                              (idx){
                            EventClass _event = eventList[idx];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: double.maxFinite,
                                  height: 240,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _event.time,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue
                                          ),
                                        ),
                                        SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 200, // Set a fixed height or adjust based on your needs

                                                child: Markdown(
                                                  controller: ScrollController(),
                                                  selectable: true,
                                                  data: _event.description,
                                                  extensionSet: md.ExtensionSet(
                                                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                                                    <md.InlineSyntax>[
                                                      md.EmojiSyntax(),
                                                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ),
                            );
                          }
                      ) : [],
                  ) ,
                  //loading indicator

                ],
              ),
            ),
          ),
          Positioned.fill(
            child: _isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(),
          ),
        ],

      ),
    );
  }
}
