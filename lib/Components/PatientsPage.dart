import 'package:flutter/material.dart';
import 'package:uci/SharedPreferencesHelper.dart';
import '../BL/PatientClass.dart';
import './Components.dart';

class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  List<PatientClass>? patientsList;




  @override
  void initState() {
    super.initState();
    loadPatients();
  }

  Future<void> loadPatients() async {
    final patients = await SharedPrefsHelper.getPatients();
    setState(() {
      patientsList = patients;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Patients",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            // search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                height: 33,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const TextField(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Search',
                    suffixIcon: Icon(Icons.search, color: Colors.blue),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // buttons
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      SharedPrefsHelper.clearPatients();
                      setState(() {
                        patientsList = null;
                      });
                    },
                    child: const SizedBox(
                      width: 70,
                      height: 30,
                      child: Center(
                        child: Text("Export All"),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      fixedSize: const Size(100, 30),
                    ),
                    onPressed: () async{
                      await Navigator.pushNamed(context, '/addPatient');
                      setState(() {
                        loadPatients();
                      });
                    },
                    child: Container(
                      width: 70,
                      height: 30,
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("New"),
                            Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // patient tiles
            Expanded(
              child: patientsList == null || patientsList!.isEmpty
                  ? const Center(child: Text("No Patients Registered!"))
                  : ListView.builder(
                itemCount: patientsList!.length,
                itemBuilder: (context, index) {
                  return patientsList![index].getTile(context, setStatte);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setStatte() {
    setState(() {
      loadPatients();
    });
  }
}
