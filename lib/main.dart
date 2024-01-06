import 'package:flutter/material.dart';
import 'package:glow_button/jelly_button.dart';

void main() {
  runApp(const MyJellyButton());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyButton(text: "Animated Gradient Button"),
              SizedBox(height: 25),
              MyButton(text: "Smaller"),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  const MyButton({super.key, required this.text});

  final String text;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final t = _animation.value;
        print(-3 + t * 1);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Colors.red,
                  Colors.purple,
                  Colors.pink,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.cyan,
                  Colors.blue,
                  Colors.red,
                ],

                // These need to be adjusted to get the same effect
                begin: Alignment(
                  -2.0 + 2.0 * t, // Adjust the starting point dynamically
                  -1.0,
                ),
                end: Alignment(
                  2.0 + 2.0 * t, // Adjust the ending point dynamically
                  1.0,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
