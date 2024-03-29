import 'package:draw_aphabest/painter_text.dart';
import 'package:draw_aphabest/text_recoragtion/pm_animation_utils.dart';
import 'package:draw_aphabest/text_recoragtion/pm_font.dart';
import 'package:draw_aphabest/text_recoragtion/pm_font_reader.dart';
import 'package:draw_aphabest/text_recoragtion/pm_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  late PMFont myFont;
  late Path myPath1;
  late Path myPath2;
  List<Widget> listCircle = [];
  late PMPieces path1Pieces;

  late Animation<int> animation;
  late AnimationController controller;

  var z = 0;
  var ready = false;

  @override
  void initState() {
    super.initState();

    rootBundle.load("assets/font2.ttf").then((ByteData data) {
      // Create a font reader
      var reader = PMFontReader();

      // Parse the font
      myFont = reader.parseTTFAsset(data);

      // Generate the complete path for a specific character
      myPath1 = myFont.generatePathForCharacter(114);

      // Move it and scale it. This is necessary because the character
      // might be too large or upside down.
      myPath1 = PMTransform.moveAndScale(myPath1, -130.0, 180.0, 0.1, 0.1);

      // Break the path into small pieces for the animation
      path1Pieces = PMPieces.breakIntoPieces(myPath1,0.01);

      // Create an animation controller as usual
      controller =
          AnimationController(vsync: this, duration: new Duration(seconds: 2));

      // Create a tween to move through all the path pieces.
      animation = IntTween(begin: 0, end: path1Pieces.paths.length - 1)
          .animate(controller);

      animation.addListener(() {
        setState(() {
          z = animation.value;
          listCircle.add(
            CustomPaint(
                painter: PMPainter(path1Pieces.paths[z],
                    indicatorPosition: path1Pieces.points[z])),
          );
        });
      });
      controller.forward();
      setState(() {
        ready = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(children: [
            Row(children: [
              TextButton(
                  child: Text("Forward"),
                  onPressed: ready
                      ? () {
                          controller.forward();
                        }
                      : null),
              Spacer(),
              TextButton(
                  child: Text("Reverse"),
                  onPressed: ready
                      ? () {
                          controller.reverse();
                        }
                      : null),
            ]),
            ready
                ? Stack(
                    children:

                      listCircle
                    ,
                  )
                : Text("Loading")
          ])),
      appBar: AppBar(title: Text("Example")),
    ));
  }
}


