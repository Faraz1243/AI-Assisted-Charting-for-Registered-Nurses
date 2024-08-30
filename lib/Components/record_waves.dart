import 'dart:math' as math;
import 'package:flutter/material.dart';

class RecordWaves extends StatefulWidget {
  final Duration duration;
  final double size;

  RecordWaves({
    super.key,
    required this.duration,
    required this.size,
  });
  @override
  State<RecordWaves> createState() => _RecordWavesState();
}

class _RecordWavesState extends State<RecordWaves>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController ;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    // Stop the animation before disposing of the controller
    animationController.stop();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(widget.duration, () => true),
        builder: (context, snapshot) {
          return FutureBuilder(
              future: Future.delayed(widget.duration, () => true),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Container();
                }

                return AnimatedBuilder(
                  animation: animationController,
                  builder: (_, __) => Transform.rotate(
                    angle: animationController.value * math.pi,
                    child: SizedBox(
                      width: widget.size ,
                      height: widget.size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: List.generate(3,
                              (index) => wave (
                                  index * ((math.pi * 0.5) / 3)
                              ),
                        ), // List.generate
                      ), // Stack
                    ), // SizedBox
                  ), // Transform.rotate
                );
              });
        });
  }

  Widget wave(double angle) => Transform.rotate(
        angle: angle,
        child: Container(
          width: math.max(widget.size , 0),
          height: math.max(widget.size , 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blue.withOpacity(0.6),
              width: 2,
            ), // Border.all
            borderRadius: BorderRadius.circular(40),
          ),
        ), // Container
      ); // Transform.rotate
}
