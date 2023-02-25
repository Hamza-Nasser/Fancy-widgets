import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class DrawWithCanvas extends StatefulWidget {
  const DrawWithCanvas({super.key});

  @override
  State<DrawWithCanvas> createState() => _DrawWithCanvasState();
}

class _DrawWithCanvasState extends State<DrawWithCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  final Duration _rotationDuration = const Duration(seconds: 20);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationController =
        AnimationController(vsync: this, upperBound: math.pi * 2);
    _rotationController.duration = _rotationDuration;
    _rotationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(
      //    title: const Text('Home page'),
      //  ),
      body: CustomPaint(
        painter: ExamplePainter(_rotationController),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class ExamplePainter extends CustomPainter {
  // this procedure is taking place of setState but in more efficient way
  // since repaint is listenable then when the animation ticks(notify listener)
  // then it repaints, no need to setState.
  final Animation<double> rotation;
  ExamplePainter(this.rotation) : super(repaint: rotation);
  final Paint _paint = Paint()..color = const Color.fromARGB(255, 156, 49, 41);
  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.shortestSide / 3;
    final center = Offset(size.width / 2, size.height / 2);
    // canvas.drawCircle(center, radius, _paint);
    // vertices will work with canvas.drawVertices
    var vertices = Vertices(
      VertexMode.triangles,
      [
        // Note: if three point are making a line then it is not a triangle
        // so it doesn't get painted on the screen
        center,
        center + const Offset(200, 0),
        center + const Offset(200, 200),
        // every three points forms a triangle
        // center,
        center + const Offset(0, 200),
        center + const Offset(200, 200),
      ],
      colors: [
        // Note: the number of colors must match the #of vertices
        // assert(vertices.length == colors.length)
        const Color.fromARGB(231, 132, 255, 71),
        const Color.fromARGB(231, 32, 15, 222),
        const Color.fromARGB(231, 255, 35, 178),
        const Color.fromARGB(231, 35, 185, 255),
        const Color.fromARGB(231, 3, 14, 19),
        // const Color.fromARGB(231, 60, 255, 161),
      ],
      // Indices tells you what vertices should I draw in order
      // at least 3 must apply and only block of 3 indices will be considered
      // like vertices
      // but with indices you can make like 100 vertex and make a multiple of 3
      // in indices
      indices: [0, 2, 3, 1, 2, 3],
    );
    // Now we want to turn into to drawVertices rows
    ///  Creates a set of vertex data for use with [Canvas.drawVertices],
    ///  directly using the encoding methods of [Vertices.new].
    ///  Note that this constructor uses raw typed data lists,
    ///  so it runs faster than the [Vertices()]
    ///  constructor because it doesn't require any conversion from Dart lists.
    // lets create positions
    // every 2 consecutive elements in the [Float32List] are equivalent to
    // an [Offset()]
    final positions = Float32List.fromList([200, 200, 300, 200, 200, 300]);
    vertices = Vertices.raw(VertexMode.triangles, positions);

    canvas.drawVertices(vertices, BlendMode.dst, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
