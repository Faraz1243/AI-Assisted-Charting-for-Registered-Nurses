import 'dart:ffi';
import 'BL/EventClass.dart';
import 'BL/PatientClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {

  static Future<String> getName() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name") ?? "";
  }

  static Future<void> setName(String name)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
  }

  static Future<void> addPatient(PatientClass patient) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> patients = prefs.getStringList("patients") ?? [];
    patients.add(patient.toString());
    prefs.setStringList("patients", patients);
    print("Patient added");
    print(patients);
  }

  static Future<List<PatientClass>> getPatients() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> patients = prefs.getStringList("patients") ?? [];
    List<PatientClass> patientList = [];
    for (String patient in patients){
      patientList.add(PatientClass.fromString(patient));
    }
    print("Patients loaded");
    print(patientList);
    return patientList;
  }

  static Future<void> clearPatients() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("patients");
  }

  static Future<void> addEvent(EventClass event) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList("events") ?? [];
    event.id = events.length;
    events.add(event.toString());
    prefs.setStringList("events", events);
    print(events);
  }

  static Future<List<EventClass>> getPatientEvents(String patient) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList("events") ?? [];
    List<EventClass> eventList = events.map((event) => EventClass.fromString(event)).toList();
    eventList = eventList.where((event) => event.patient == patient).toList();
    print(eventList);
    return eventList;
  }

  static Future<void> delPatientEvents(String patient) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> events = prefs.getStringList("events") ?? [];
    List<EventClass> eventList = events.map((event) => EventClass.fromString(event)).toList();
    eventList = eventList.where((event) => event.patient != patient).toList();
    List<String> newEvents = eventList.map((event) => event.toString()).toList();
    prefs.setStringList("events", newEvents);
  }

  static Future<void> delPatient(String patient) async{
    // Assuming `patient` is the name of the patient to be deleted
    final SharedPreferences prefs = await SharedPreferences.getInstance();

// Retrieve and deserialize the list of patients
    List<String> patients = prefs.getStringList("patients") ?? [];
    List<PatientClass> patientList = patients.map((patientString) => PatientClass.fromString(patientString)).toList();

// Filter out the patient to be deleted
    patientList = patientList.where((p) => p.name != patient).toList();

// Serialize the updated list of patients
    List<String> newPatients = patientList.map((p) => p.toString()).toList();
    prefs.setStringList("patients", newPatients);

// Assuming `delPatientEvents` is a function to handle events for the deleted patient
    delPatientEvents(patient);

// Print statement to debug
    print("\n\n\n\n $patient patient deleted. New patients list: $newPatients\n\n\n\n");

  }






  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}
