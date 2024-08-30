import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:uci/Components/record_button.dart';
import '../SharedPreferencesHelper.dart';
import './../ChatGPT.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  void getName() async {
    name = await SharedPrefsHelper.getName();
    setState(() {});
  }

  @override
  void initState() {
    getName();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Greetings!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            RecordButton(),

            // // button
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
// //huge circle with mic icon in center
//                   GestureDetector(
//                     onTap: () async {
//                       if (_isRecording) {
//                         setState(() {
//                           _isLoading = true; // Start loading
//                         });
//
//                         String? filePath = await audioRecorder.stop();
//                         if (filePath != null) {
//                           setState(() {
//                             _isRecording = !_isRecording;
//                             print(filePath);
//                           });
//
//                           String transcription = await transcribeAudio(filePath,);
//                           setState(() {
//                             caption = transcription;
//                           });
//                           await Navigator.pushNamed(context, '/addEvent',
//                               arguments: transcription);
//                           setState(() {
//                             _isLoading = false;
//                             caption = ""; // Stop loading
//                           });
//                         }
//                       } else {
//                         if (await audioRecorder.hasPermission()) {
//                           final Directory dir =
//                               await getApplicationDocumentsDirectory();
//                           final String path = p.join(dir.path, 'audio.m4a');
//                           await audioRecorder.start(const RecordConfig(),
//                               path: path);
//                           setState(() {
//                             _isRecording = !_isRecording;
//                           });
//                         }
//                       }
//                     },
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         color: _isRecording ? Colors.blue : Colors.white,
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.3),
//                             spreadRadius: 10,
//                             blurRadius: 7,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.mic,
//                         size: 100,
//                         color: _isRecording ? Colors.white : Colors.blue,
//                       ),
//                     ),
//                   ),
//                   _isRecording
//                       ? const Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text("Recording",
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.normal,
//                               )),
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),

            // loading circle
            // Positioned.fill(
            //   child: _isLoading
            //       ? const Center(
            //           child: CircularProgressIndicator(),
            //         )
            //       : Container(),
            // ),
          ],
        ),
      ),
    );
  }
}
