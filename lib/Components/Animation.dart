import 'package:flutter/material.dart';
import 'package:uci/Components/record_button.dart';

class Animationn extends StatefulWidget {
  const Animationn({super.key});

  @override
  State<Animationn> createState() => _AnimationnState();
}

class _AnimationnState extends State<Animationn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: RecordButton()),
    );
  }
}
