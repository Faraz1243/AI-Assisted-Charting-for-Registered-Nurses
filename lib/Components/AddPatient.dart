import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './../SharedPreferencesHelper.dart';
import '../BL/PatientClass.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({super.key});

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(flex:1, child: Text('Name')),
                Expanded(flex: 2, child: TextField( controller: nameController,onChanged: (val){nameController.text = val.toUpperCase();},)),
              ],
            ),
            const SizedBox(height: 12,),

            Row(
              children: [
                const Expanded(child: Text('Age'), flex: 1,),
                Expanded(flex: 2,child:
                  TextField(controller: ageController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],),
                ),
              ],
            ),
            const SizedBox(height: 12,),

            Row(
              children: [
                Expanded(child: Text('Gender'), flex: 1),
                Expanded(
                  flex: 2,
                  child: DropdownMenu(
                    controller: genderController,
                    width: double.maxFinite,
                    dropdownMenuEntries: const [
                      DropdownMenuEntry(
                        value: 0,
                        label: 'Male',
                      ),
                      DropdownMenuEntry(
                        value: 1,
                        label: 'Female',
                      ),
                      DropdownMenuEntry(
                        value: 2,
                        label: 'Non Binary',
                      ),
                    ]
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12,),

            Center(
              child: ElevatedButton(
                onPressed: (){
                  int gender = 0;
                  switch (genderController.value.text) {
                    case "Female":
                      gender = 1;
                      break;
                    case "Non Binary":
                      gender = 2;
                      break;
                    default:
                      gender = 0;
                      break;
                  }
                  print(genderController.value.text);
                  PatientClass p = PatientClass(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      gender: gender,
                  );

                  SharedPrefsHelper.addPatient(p);

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Patient Added"),
                          content: const Text("Patient added successfully!"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      }
                  );
                },
                child: const Text("Add Patient"),
              ),
            ),
            const SizedBox(height: 50,),
          ],
        ),
      ),
    );
  }
}
