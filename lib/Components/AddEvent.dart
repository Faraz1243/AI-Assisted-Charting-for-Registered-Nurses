import 'package:flutter/material.dart';
import 'package:uci/BL/EventClass.dart';

import '../BL/PatientClass.dart';
import '../ChatGPT.dart';
import '../SharedPreferencesHelper.dart';

class AddEvent extends StatefulWidget {
  final String micRec;

  const AddEvent({
    super.key,
    required this.micRec,
  });

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  List<PatientClass>? patientsList;
  TextEditingController finalTextController = TextEditingController();

  @override
  void initState() {
    finalTextController.text = "${widget.micRec}\n\n\n\n\n";
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    final patients = await SharedPrefsHelper.getPatients();
    setState(() {
      patientsList = patients;
    });
  }

  int idx = -1;
  bool isLoading = false;

  Future<String> loadCSV(String report) async {
    String reportCSV = await ChatGPTclass.getTabularData(report);
    return reportCSV;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Add Event'),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  if (idx == -1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a Patient'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    String? patientName =
                        "Patient: ${patientsList?[idx!].name} \n\n";
                    await ChatGPTclass.getCharting(
                            "$patientName ${finalTextController.text}")
                        .then((markdown) async {
                      markdown = removeSterics(markdown);
                      await loadCSV(finalTextController.text).then((csv) async {
                        EventClass e = EventClass(
                          patient: patientsList![idx!].name,
                          date: DateTime.now().toString(),
                          description: markdown,
                          time: DateTime.timestamp().toLocal().toString(),
                          table: csv,
                        );
                        SharedPrefsHelper.addEvent(e);
                        await Navigator.pushNamed(context, '/textReport',
                            arguments: [markdown, csv]);
                        setState(() {
                          isLoading = false;
                        });
                      }, onError: (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    }, onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                        width: double.maxFinite,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text("Patient"),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: DropdownMenu(
                                    width: double.maxFinite,
                                    onSelected: (value) {
                                      idx = value as int;
                                    },
                                    dropdownMenuEntries: patientsList != null
                                        ? List.generate(
                                            patientsList!.length,
                                            (index) {
                                              return DropdownMenuEntry(
                                                value: index,
                                                label:
                                                    patientsList![index].name,
                                              );
                                            },
                                          )
                                        : [],
                                  ))
                            ],
                          ),
                        ))),

                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 6, 0, 12),
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // apply border to top only
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "Audio Transcription",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: TextField(
                                controller: finalTextController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ),
      ],
    );
  }
}

String removeSterics(String s) {
  return s.replaceAll(RegExp(r'\*'), '');
}
