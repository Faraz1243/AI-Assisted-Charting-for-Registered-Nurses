import 'package:flutter/material.dart';
import 'package:uci/SharedPreferencesHelper.dart';

class Wellcome extends StatefulWidget {
  const Wellcome({super.key});

  @override
  State<Wellcome> createState() => _WellcomeState();
}

class _WellcomeState extends State<Wellcome> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(40.0),
                  child: Image(image: AssetImage("assets/icon.png"), height: 130,),
                ),
                const Center(
                  child: Text(
                      "Wellcome to AI Assisted Charting!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ),
                const SizedBox(height: 16,),
                const Text(
                  "Thank You for your dedication and hard work, Nurses!"
                ), const SizedBox(height: 22,),
                TextField(
                  controller: nameController,
                  onChanged: (val){nameController.text = val.toUpperCase();},
                  decoration: InputDecoration(
                    hintText: "What's your name",
                    labelText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ), const SizedBox(height: 28,),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                    onPressed: ()async{
                      await SharedPrefsHelper.setName(nameController.text);
                      Navigator.pushReplacementNamed(context, '/random');
                    },
                    child: Container(
                      width: 100,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.arrow_forward_outlined),
                          Text("Continue"),
                        ],
                      ),
                    ),
                ),
                const SizedBox(height: 100,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
