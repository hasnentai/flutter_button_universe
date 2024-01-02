import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xff1d1e22),
        appBar: AppBar(
          title: Text('Blob Button'),
        ),
        body: Center(
          child: BlobButton(),
        ),
      ),
    );
  }
}

class BlobButton extends StatefulWidget {
  @override
  _BlobButtonState createState() => _BlobButtonState();
}

class _BlobButtonState extends State<BlobButton> with TickerProviderStateMixin {
  late List<AnimationController> controllers;
  late Animation<Color?> colorAnimations;
  late List<Animation<dynamic>> animations;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      5,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 300,
        ),
      ),
    );

    animations = controllers
        .map((controller) =>
            Tween<double>(begin: 0.0, end: 1.0).animate(controller))
        .toList();

    colorAnimations =
        ColorTween(begin: Color(0xff0505A9), end: Colors.white).animate(
      controllers[0],
    );
  }

  void _forwardAnimations() {
    for (int i = 0; i < controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        controllers[i].forward();
      });
    }
  }

  void _reverseAnimations() {
    for (int i = 0; i < controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        controllers[i].reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        _forwardAnimations();
      },
      onExit: (event) {
        _reverseAnimations();
      },
      child: AnimatedBuilder(
          animation: Listenable.merge(animations),
          builder: (context, _) {
            return ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(30),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: CustomPaint(
                      painter: BlobPainter(
                        animations,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Color(0xff0505A9),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Text(
                      'Blob Button ',
                      style: TextStyle(
                        color: colorAnimations.value,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class BlobPainter extends CustomPainter {
  final List<Animation<dynamic>> animations;

  BlobPainter(this.animations);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xff0505A9)
      ..style = PaintingStyle.fill;

    final double blobRadius = size.width * 25 / 100;
    final double gooeyRadius = blobRadius * 2;

    for (int i = 0; i < 5; i++) {
      final double x = i * (size.width / 4);
      final double y = size.height + blobRadius;

      final double translateY = (blobRadius * (animations[i].value));

      canvas.save();
      canvas.translate(x, y);

      canvas.translate(0, -translateY);

      canvas.drawCircle(Offset(0, 0), blobRadius, paint);

      // Draw gooey effect between circles
      if (i < 4) {
        final double nextX = (i + 1) * (size.width / 4);
        final double nextY = size.height + blobRadius;
        final double controlX = (x + nextX) / 2;
        final double controlY = size.height + gooeyRadius;

        final Path path = Path()
          ..moveTo(x + blobRadius, y)
          ..quadraticBezierTo(controlX, controlY, nextX - blobRadius, nextY)
          ..arcToPoint(
            Offset(nextX, nextY - gooeyRadius),
            radius: Radius.circular(gooeyRadius),
            clockwise: false,
          )
          ..quadraticBezierTo(controlX, controlY, x + blobRadius, y);

        canvas.drawPath(path, paint);
      }
//
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
