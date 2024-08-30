class EventClass{
  int? id;
  String patient;
  String time;
  String date;
  String description;
  String table;

  EventClass({required this.patient, required this.time, required this.date, required this.description, required this.table});
  EventClass.withId({required this.id, required this.patient, required this.time, required this.date, required this.description, required this.table});


  static EventClass fromString(String event){
    List<String> eventList = event.split("~");
    int id = int.parse(eventList[0]);
    String patient = eventList[1];
    String time = eventList[2];
    String date = eventList[3];
    String description = eventList[4];
    String table = eventList[5];

    return EventClass.withId(
        id: id,
        patient: patient,
        time: time,
        date: date,
        description: description,
        table: table
    );
  }

  @override
  String toString() {
    return "$id~$patient~$time~$date~$description~$table";
  }
}