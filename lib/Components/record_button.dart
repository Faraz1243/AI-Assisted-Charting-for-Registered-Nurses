import 'dart:convert';
import 'dart:io';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;
import '../Config.dart';
import 'record_waves.dart';
import './../config.json' as Config;

class RecordButton extends StatefulWidget {
  const RecordButton({super.key});

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  final duration = const Duration(milliseconds: 300);
  var isRecording = false;

  String apiKey = Configs.OpenAI;
  bool _isLoading = false;
  final audioRecorder = AudioRecorder();
  String caption = "";

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.6;
    return Center(
      child: Stack(alignment: Alignment.center, children: [
        if (isRecording)
          RecordWaves(
            duration: duration,
            size: width,
          ),
        AnimatedContainer(
          width: isRecording ? width : width * 1.2,
          height: isRecording ? width : width * 1.2,
          duration: duration,
          decoration: BoxDecoration(
              border: Border.all(
                color: isRecording ? Colors.white10 : Colors.white,
                width: isRecording ? 1 : 1,
              ), // Border.all
              borderRadius: BorderRadius.circular(width)), // BoxDecoration
          child: tapButton(width),
        ),
        Positioned.fill(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(),
        ),
      ] // tedContainer
          ),
    );
  }

  Widget tapButton(double size) => Center(
        child: GestureDetector(
          onTap: () async {
            if (isRecording) {
              setState(() {
                _isLoading = true; // Start loading
              });

              String? filePath = await audioRecorder.stop();

              if (filePath != null) {
                setState(() {
                  isRecording = !isRecording;
                  print(filePath);
                });

                String transcription = await transcribeAudio(filePath, apiKey);
                setState(() {
                  caption = transcription;
                });
                await Navigator.pushNamed(context, '/addEvent',
                    arguments: transcription);
                setState(() {
                  _isLoading = false;
                  caption = ""; // Stop loading
                });
              }
            } else {
              if (await audioRecorder.hasPermission()) {
                final Directory dir = await getApplicationDocumentsDirectory();
                final String path = p.join(dir.path, 'audio.m4a');
                await audioRecorder.start(const RecordConfig(), path: path);
                setState(() {
                  isRecording = !isRecording;
                });
              }
            }
          },
          child: AnimatedContainer(
              duration: duration,
              width: isRecording ? size * 0.65 - 30 : size * 0.80,
              height: isRecording ? size * 0.65 - 30 : size * 0.80,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: isRecording ? 4 : 8,
                  ), // Border.all
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    isRecording ? 20 : 100,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isRecording
                          ? Colors.blue.withOpacity(0.4)
                          : Colors.black.withOpacity(0.1),
                      blurRadius: isRecording ? 17.5 : 20.0,
                      spreadRadius: isRecording ? 7.5 : 10.0,
                    )
                  ]),
              child: Center(
                  child: isRecording
                      ? Icon(Icons.stop, size: 40, color: Colors.blue)
                      : Icon(Icons.mic, size: 80, color: Colors.blue))),
        ),
      );
}

Future<String> transcribeAudio(String filePath, String apiKey) async {
  var uri = Uri.parse('https://api.openai.com/v1/audio/transcriptions');

  var request = http.MultipartRequest('POST', uri)
    ..headers['Authorization'] = 'Bearer $apiKey'
    ..headers['Content-Type'] = 'multipart/form-data'
    ..files.add(await http.MultipartFile.fromPath('file', filePath))
    ..fields['model'] = 'whisper-1';

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);
      print('Transcription: ${jsonResponse['text']}');
      return jsonResponse['text'];
    } else {
      print('Failed to transcribe audio. Status code: ${response.statusCode}');
      return 'Failure';
    }
  } catch (e) {
    print('Error: $e');
    return 'Error: $e';
  }
}
