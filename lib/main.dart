import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'point.dart';

const period = Duration(milliseconds: 100);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return const MaterialApp(
      title: 'GestureDetector',
      home: GestureDetectorWidget(),
    );
  }
}

class GestureDetectorWidget extends StatefulWidget {
  const GestureDetectorWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GestureDetectorWidgetState();
}

class _GestureDetectorWidgetState extends State<GestureDetectorWidget> {
  List<Offset> staticData = [];
  List<Point> dynamicData = [];
  int count = 0;
  Point? point;
  late Timer timer;

  void startTimer(Offset offset) {
    point = Point(offset, 10);
    timer = Timer.periodic(
      period,
          (Timer timer) {
        point?.time++;
      },
    );
  }
  GlobalKey key = GlobalKey();
  Offset offsetLocal = Offset(0, 0);
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomPaint(
        foregroundPainter: MyCustomPainter( staticData: staticData,
          dynamicData: dynamicData,), //draws red dots based on child's size
        child: GestureDetector(
            onPanStart: (offset) {
              setState(() {
                staticData.add(Offset(offset.localPosition.dx - 5, offset.localPosition.dy - 5));
                count++;
                RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
                Offset position = box.localToGlobal(Offset.zero);
                offsetLocal = position;
              });
            },
            onPanUpdate: (offset) {
              print(offset.localPosition.dx);
              setState(() {

                    staticData.add(Offset(offset.localPosition.dx - 5, offset.localPosition.dy - 5));
                    count++;

              });

            },
            onLongPressStart: (offset) {
              setState(() {
                staticData.add(Offset(offset.localPosition.dx - 5, offset.localPosition.dy - 5));
                count++;
              });
            },
            onLongPressEnd: (offset) {
              if (point == null) return;
              setState(() {
                dynamicData.add(
                  Point(
                      Offset(
                        point!.offset.dx - point!.time / 2,
                        point!.offset.dy - point!.time / 2,
                      ),
                      point!.time),
                );
              });
              point = null;
              timer.cancel();
            },
            child: Center(child: Text(
              key: key,'T',style: const TextStyle(color: Colors.black, fontSize:300),))), //textbox
      )
    );
  }
}

class MyCustomPainter extends CustomPainter {
  MyCustomPainter({
    required this.staticData,
    required this.dynamicData,
  });

  final List<Offset> staticData;
  final List<Point> dynamicData;

  @override
  void paint(Canvas canvas, Size size) {
    for (var offset in staticData) {
      canvas.drawCircle(offset, 10, Paint()..color = Colors.red);
    }
    for (var point in dynamicData) {
      canvas.drawCircle(point.offset, point.time, Paint()..color = Colors.blue);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
