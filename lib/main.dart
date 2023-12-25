import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyButton(),
        ),
      ),
    );
  }
}

class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
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
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: -580,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1, curve: Curves.linear),
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 220,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: _animation.value,
                        child: Container(
                          width: 800,
                          height: 50,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.red,
                              )
                            ],
                            gradient: LinearGradient(
                              colors: [
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
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Animated Gradient Button",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
